import 'dart:convert';

void main(List<String> args) {
  String str = r"""{
"additional_resources": "Fundamentals of Physics by Halliday and Resnick, 10th Edition, ch21, pages 609-624\n\nCollege Physics by Raymond Serway, Chris Vuille, Jerry S. Faughn, 8th Ed. ch21, pages 497-505",
"completion_points": "50",
"depends_on_id": null,
"id": 1,
"slide_link": "https://physiks.fun#slides",
"summary": "<h3>Properties of Electric Charges</h3>\n\n<p><strong>Electric charges</strong> have the following properties:</p>\n\n<ol>\n\t<li>Unlike charges attract one another and like charges repel one another.&nbsp;</li>\n\t<li>Electric charge is always conserved.</li>\n\t<li>Charge comes in discrete packets that are integral multiples of the basic electric charge <img src=\"data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==\" /><br />\n\t<img alt=\"e=1.63\\times10^{-19}C\" src=\"http://latex.codecogs.com/svg.latex?e%3D1.63%5Ctimes10%5E%7B-19%7DC\" /></li>\n\t<li>The force between two charged particles is proportional to the inverse square of the distance between them.</li>\n</ol>\n\n<h3>Insulators and Conductors</h3>\n\n<p>&nbsp;</p>\n\n<p>Conductors are materials in which charges move freely in response to an electric field. All other materials are called insulators.</p>\n\n<h3>Coulomb&rsquo;s Law</h3>\n\n<p>Coulomb&rsquo;s law states that the electric force between two stationary charged particles separated by a distance r has the magnitude</p>\n\n<p><span class=\"math-tex\">\\(F = k_e \\dfrac{|q_1||q_2|}{r^2}\\)</span></p>\n\n<p>where q1 and q2 are the magnitudes of the charges on the particles in coulombs and</p>\n\n<p>My guy <span class=\"math-tex\">\\(k=8.99\\times10^9N\\cdot m^2 /C^2\\)</span>&nbsp;is the coulomb constant.</p>\n\n<p>The electrostatic force vector acting on a charged particle due to a second charged particle is either directly toward the second particle (opposite signs of charge) or directly away from it (same sign of charge). As with other types of forces, If multiple electrostatic forces act on a particle, the net force is the <strong>vector sum (not scalar sum)</strong> of the individual forces. The two shell theories for electrostatics are</p>\n\n<p><strong>Shell theorem 1:</strong> A charged particle outside a shell with charge uniformly distributed on its surface is attracted or repelled as if the shell&rsquo;s charge were concentrated as a particle at its center.<br />\n<strong>Shell theorem 2:</strong> A charged particle inside a shell with charge uniformly distributed on its surface has no net force acting on it due to the shell. Charge on a conducting spherical shell spreads uniformly over the (external) surface.</p>",
"title": "Electric Charge and Forces"
}
""";

  Map str2 = json.decode(str);

  // print(str2['summary']);

  print(json.decode(json.encode(str2))['summary']);
}

