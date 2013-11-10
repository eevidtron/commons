
$fs = 0.1;
$fa = 3;

module node(p1)
{
	translate(p1) sphere(10);
}

module edge(p1, p2)
{
	dist = p2 - p1;
	dnorm = sqrt(pow(dist[0], 2) + pow(dist[1], 2) + pow(dist[2], 2));
	dir = dist / dnorm;
	axis = [ dir[1], -dir[0], 0 ];
	angle = acos(-dir[2]);
	translate(p2) rotate(angle, axis) cylinder(r = 8, h = dnorm);
}

module edge_nodes(p1, p2)
{
	node(p1);
	node(p2);
	edge(p1, p2);
}

module currsource(inner)
{
	for (x = [330, 370])
		translate([x, 0, 0]) rotate_extrude(convexity = 2)
			if (inner)
				translate([10, -10]) square(20);
			else
				translate([30, 0]) circle(r = 8);
	if (inner)
		translate([310, 0, 0]) rotate([0, 90, 0]) cylinder(h = 80, r = 10);
}

module diode(inner)
{
	if (inner)
		cylinder(r = 10, h = 34, center = true);
	else
		translate([0, 0, -35/2]) {
			cylinder(r1 = 15, r2 = 5, h = 35);
			translate([0, 0, 30]) cylinder(r = 15, h = 5);
		}
}

module eevidtron_logo()
{
	// main Triangle (without left edge)

	p1 = [0, -200, 0];
	p2 = [0, +200, 0];
	p3 = [300, 0,  0];

	edge_nodes(p1, p3);
	edge_nodes(p2, p3);


	// pins on the left

	p4 = 0.2 * p1 + 0.8 * p2;
	p5 = p4 + [-100, 0, 0];

	p6 = 0.5 * p1 + 0.5 * p2;
	p7 = p6 + [-100, 0, 0];

	p8 = 0.8 * p1 + 0.2 * p2;
	p9 = p8 + [-100, 0, 0];

	edge_nodes(p4, p5);
	edge_nodes(p6, p7);
	edge_nodes(p8, p9);


	// diodes and left triangle edge

	difference() {
		edge(p1, p2);
		translate(0.5*p4 + 0.5*p6) rotate([-90, 0, 0]) diode(true);
		translate(0.5*p8 + 0.5*p6) rotate([+90, 0, 0]) diode(true);
	}

	translate(0.5*p4 + 0.5*p6) rotate([-90, 0, 0]) diode(false);
	translate(0.5*p8 + 0.5*p6) rotate([+90, 0, 0]) diode(false);


	// supply pins

	p10 = 0.5 * (p1 + p3);
	p11 = p10 + [0, -100, 0];

	p12 = 0.5 * (p2 + p3);
	p13 = p12 + [0, +100, 0];

	edge_nodes(p10, p11);
	edge_nodes(p12, p13);


	// output and ref current

	p14 = p3 + [200, 0, 0];
	p15 = p3 + [50, 0, 0];
	p16 = p15 + [0, -100, 0];

	difference() {
		union() {
			node(p14);
			edge(p3, p14);
			edge_nodes(p15, p16);
		}
		currsource(true);
	}
	currsource(false);
}

eevidtron_logo();

