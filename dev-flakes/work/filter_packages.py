import os
import tomllib
import tomli_w

PACKAGE_TO_REMOVE = os.environ.get("PACKAGE_TO_REMOVE", "gssapi")
LOCK_FILE = "uv.lock"
FILTERED_LOCK = "uv.lock.filtered"


def is_target(entry):
    return isinstance(entry, dict) and entry.get("name") == PACKAGE_TO_REMOVE


def clean_deps_list(deps):
    return [dep for dep in deps if not is_target(dep)]


with open(LOCK_FILE, "rb") as f:
    data = tomllib.load(f)

# Remove packages named 'gssapi'
data["package"] = [
    pkg for pkg in data.get("package", []) if pkg.get("name") != PACKAGE_TO_REMOVE
]

# Clean dependencies inside each package
for pkg in data.get("package", []):
    if "dependencies" in pkg:
        pkg["dependencies"] = clean_deps_list(pkg["dependencies"])

# Clean [package.optional-dependencies] section
optional_deps = data.get("package", [])
for pkg in optional_deps:
    if "optional-dependencies" in pkg:
        od = pkg["optional-dependencies"]
        for key in list(od.keys()):
            od[key] = clean_deps_list(od[key])
            if not od[key]:  # remove key if list is empty
                del od[key]

# Clean [[package.metadata.requires-dist]] entries
for pkg in data.get("package", []):
    if "metadata" in pkg and "requires-dist" in pkg["metadata"]:
        pkg["metadata"]["requires-dist"] = clean_deps_list(
            pkg["metadata"]["requires-dist"]
        )

# Save result
with open(FILTERED_LOCK, "wb") as f:
    f.write(tomli_w.dumps(data).encode("utf-8"))
