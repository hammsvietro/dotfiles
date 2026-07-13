# Truecolor Mandelbrot greeter. Renders with upper-half-block glyphs so each
# character cell carries two vertically-stacked pixels (fg = top, bg = bottom).
# The side panel lines come in via $GREETER_PANEL and are drawn at a fixed
# column so ANSI widths never have to be counted.
function frac(x) { return x - int(x) }

function lerp(a, b, t) { return a + (b - a) * t }

# Cyclic One Dark color wheel indexed by t in [0,1); returns "r;g;b".
function wheel(t,   n, i, cr, cg, cb, f) {
  n = NSTOP
  t = frac(t) * (n - 1)
  i = int(t)
  f = t - i
  cr = lerp(SR[i], SR[i + 1], f)
  cg = lerp(SG[i], SG[i + 1], f)
  cb = lerp(SB[i], SB[i + 1], f)
  return int(cr) ";" int(cg) ";" int(cb)
}

function color_of(px, py,   x0, y0, x, y, x2, y2, iter, mu, mag) {
  x0 = CX + (px / W - 0.5) * SPAN
  y0 = CY + (py / H - 0.5) * SPAN * (H / W) * ASPECT
  x = 0; y = 0; x2 = 0; y2 = 0; iter = 0
  while (x2 + y2 <= 512 && iter < MAXIT) {
    y = 2 * x * y + y0
    x = x2 - y2 + x0
    x2 = x * x
    y2 = y * y
    iter++
  }
  if (iter >= MAXIT) return INTERIOR
  mag = sqrt(x2 + y2)
  mu = iter + 1 - log(log(mag) / log(2)) / log(2)
  if (mu < 0) mu = 0
  return wheel(sqrt(mu) * DENSITY)
}

BEGIN {
  NSTOP = 8
  SR[0]=97;  SG[0]=175; SB[0]=239
  SR[1]=86;  SG[1]=182; SB[1]=194
  SR[2]=152; SG[2]=195; SB[2]=121
  SR[3]=229; SG[3]=192; SB[3]=123
  SR[4]=209; SG[4]=154; SB[4]=102
  SR[5]=224; SG[5]=108; SB[5]=117
  SR[6]=198; SG[6]=120; SB[6]=221
  SR[7]=97;  SG[7]=175; SB[7]=239

  INTERIOR = "12;9;20"

  if (W == "")       W = 52
  if (ROWS == "")    ROWS = 20
  if (MAXIT == "")   MAXIT = 200
  if (CX == "")      CX = -0.75
  if (CY == "")      CY = 0.0
  if (SPAN == "")    SPAN = 3.2
  if (DENSITY == "") DENSITY = 0.9
  if (ASPECT == "")  ASPECT = 1.0
  if (PANELCOL == "") PANELCOL = W + 4
  if (PANELPAD == "") PANELPAD = 0

  H = ROWS * 2

  np = split(ENVIRON["GREETER_PANEL"], panel, "\036")

  for (row = 0; row < ROWS; row++) {
    line = ""
    prevtop = ""; prevbot = ""
    for (px = 0; px < W; px++) {
      top = color_of(px, row * 2)
      bot = color_of(px, row * 2 + 1)
      if (top != prevtop || bot != prevbot) {
        line = line "\033[38;2;" top "m\033[48;2;" bot "m"
        prevtop = top; prevbot = bot
      }
      line = line "\342\226\200"
    }
    line = line "\033[0m"
    pidx = row - PANELPAD + 1
    if (pidx >= 1 && pidx <= np && panel[pidx] != "")
      line = line "\033[" PANELCOL "G" panel[pidx]
    print line
  }
}
