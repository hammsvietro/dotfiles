#include <math.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    double r, g, b;
} rgb;

static rgb hsv2rgb(double h, double s, double v) {
    double c = v * s;
    double hp = fmod(h / 60.0, 6.0);
    if (hp < 0)
        hp += 6.0;
    double x = c * (1 - fabs(fmod(hp, 2) - 1));
    double r, g, b;
    if (hp < 1) {
        r = c; g = x; b = 0;
    } else if (hp < 2) {
        r = x; g = c; b = 0;
    } else if (hp < 3) {
        r = 0; g = c; b = x;
    } else if (hp < 4) {
        r = 0; g = x; b = c;
    } else if (hp < 5) {
        r = x; g = 0; b = c;
    } else {
        r = c; g = 0; b = x;
    }
    double m = v - c;
    rgb out = { r + m, g + m, b + m };
    return out;
}

/* Signed distance to a rounded rectangle centered at the origin. Negative inside. */
static double rrect_sdf(double x, double y, double halfW, double halfH, double radius) {
    double qx = fabs(x) - (halfW - radius);
    double qy = fabs(y) - (halfH - radius);
    double ax = fmax(qx, 0.0);
    double ay = fmax(qy, 0.0);
    return sqrt(ax * ax + ay * ay) + fmin(fmax(qx, qy), 0.0) - radius;
}

int main(int argc, char **argv) {
    int width = argc > 1 ? atoi(argv[1]) : 1920;
    int height = argc > 2 ? atoi(argv[2]) : 1080;
    double cx = -0.6, cy = 0.0, scale = 2.6;
    int maxIter = 300;

    double panelCx = width * 0.28;
    double panelCy = height * 0.50;
    double panelHalfW = width * 0.22;
    double panelHalfH = height * 0.30;
    double panelRadius = 30.0;

    printf("P6\n%d %d\n255\n", width, height);

    unsigned char *row = malloc((size_t) width * 3);

    for (int py = 0; py < height; py++) {
        double y0 = (py - height / 2.0) / (height / scale) + cy;
        for (int px = 0; px < width; px++) {
            double x0 = (px - width / 2.0) / (height / scale) + cx;
            double x = 0, y = 0;
            int iter = 0;
            while (x * x + y * y <= 4.0 && iter < maxIter) {
                double xt = x * x - y * y + x0;
                y = 2 * x * y + y0;
                x = xt;
                iter++;
            }

            double dx = px - width / 2.0;
            double dy = py - height / 2.0;
            double dist = sqrt(dx * dx + dy * dy);
            double angle = atan2(dy, dx);

            int symmetry = 9;
            double wedge = M_PI / symmetry;
            double folded = fabs(fmod(angle, 2.0 * wedge));
            if (folded > wedge)
                folded = 2.0 * wedge - folded;

            double mandala = sin(folded * symmetry * 3.0 - dist * 0.045) * 0.16;
            double rings = sin(dist / 26.0) * 0.10;

            double r, g, b;
            if (iter >= maxIter) {
                r = g = b = 6.0 / 255.0;
            } else {
                double logzn = log(x * x + y * y) / 2.0;
                double nu = log(logzn / log(2.0)) / log(2.0);
                double smooth = iter + 1 - nu;
                double hue = fmod(smooth * 8.0 + dist * 0.22 + folded * 260.0 + 180.0, 360.0);
                double val = fmin(1.0, fmax(0.0, 0.52 + rings + mandala));
                rgb col = hsv2rgb(hue, 0.92, val);
                r = col.r; g = col.g; b = col.b;
            }

            double sdf = rrect_sdf(px - panelCx, py - panelCy, panelHalfW, panelHalfH, panelRadius);
            double coverage = 1.0 - fmin(1.0, fmax(0.0, (sdf + 2.0) / 4.0));
            if (coverage > 0.0) {
                double alpha = coverage * 0.70;
                double pr = 10.0 / 255.0, pg = 8.0 / 255.0, pb = 20.0 / 255.0;
                r = r * (1.0 - alpha) + pr * alpha;
                g = g * (1.0 - alpha) + pg * alpha;
                b = b * (1.0 - alpha) + pb * alpha;
            }

            row[px * 3 + 0] = (unsigned char) (fmin(1.0, fmax(0.0, r)) * 255);
            row[px * 3 + 1] = (unsigned char) (fmin(1.0, fmax(0.0, g)) * 255);
            row[px * 3 + 2] = (unsigned char) (fmin(1.0, fmax(0.0, b)) * 255);
        }
        fwrite(row, 1, (size_t) width * 3, stdout);
    }
    free(row);
    return 0;
}
