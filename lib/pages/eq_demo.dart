import 'package:aceup/util/custom_html.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class EqDemo extends StatelessWidget {
  static String str = r"""{
"additional_resources": "Fundamentals of Physics by Halliday and Resnick, 10th Edition, ch21, pages 609-624\n\nCollege Physics by Raymond Serway, Chris Vuille, Jerry S. Faughn, 8th Ed. ch21, pages 497-505",
"completion_points": "50",
"depends_on_id": null,
"id": 1,
"slide_link": "https://physiks.fun#slides",
"summary": "<h3>Properties of Electric Charges</h3>\n\n<p><strong>Electric charges</strong> have the following properties:</p>\n\n<ol>\n\t<li>Unlike charges attract one another and like charges repel one another.&nbsp;</li>\n\t<li>Electric charge is always conserved.</li>\n\t<li>Charge comes in discrete packets that are integral multiples of the basic electric charge <img src=\"data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==\" /><br />\n\t<img alt=\"e=1.63\\times10^{-19}C\" src=\"http://latex.codecogs.com/svg.latex?e%3D1.63%5Ctimes10%5E%7B-19%7DC\" /></li>\n\t<li>The force between two charged particles is proportional to the inverse square of the distance between them.</li>\n</ol>\n\n<h3>Insulators and Conductors</h3>\n\n<p>&nbsp;</p>\n\n<p>Conductors are materials in which charges move freely in response to an electric field. All other materials are called insulators.</p>\n\n<h3>Coulomb&rsquo;s Law</h3>\n\n<p>Coulomb&rsquo;s law states that the electric force between two stationary charged particles separated by a distance r has the magnitude</p>\n\n<p><span class=\"math-tex\">\\(F = k_e \\dfrac{|q_1||q_2|}{r^2}\\)</span></p>\n\n<p>where q1 and q2 are the magnitudes of the charges on the particles in coulombs and</p>\n\n<p>My guy <span class=\"math-tex\">\\(k=8.99\\times10^9N\\cdot m^2 /C^2\\)</span>&nbsp;is the coulomb constant.</p>\n\n<p>The electrostatic force vector acting on a charged particle due to a second charged particle is either directly toward the second particle (opposite signs of charge) or directly away from it (same sign of charge). As with other types of forces, If multiple electrostatic forces act on a particle, the net force is the <strong>vector sum (not scalar sum)</strong> of the individual forces. The two shell theories for electrostatics are</p>\n\n<p><strong>Shell theorem 1:</strong> A charged particle outside a shell with charge uniformly distributed on its surface is attracted or repelled as if the shell&rsquo;s charge were concentrated as a particle at its center.<br />\n<strong>Shell theorem 2:</strong> A charged particle inside a shell with charge uniformly distributed on its surface has no net force acting on it due to the shell. Charge on a conducting spherical shell spreads uniformly over the (external) surface.</p>",
"title": "Electric Charge and Forces"
}
""";

static String withImg = """
<p>Qualitative test is carried out on a new organic compound to be able to identify all the elemental composition of the compound through some basic test, this is called Qualitative analysis. The basic organic compound qualitative tests are summarized below:&nbsp;<br />\n&nbsp;</p>\n\n<table border=\"1\" bordercolor=\"#ccc\" cellpadding=\"5\" cellspacing=\"0\" style=\"border-collapse:collapse\">\n\t<tbody>\n\t\t<tr>\n\t\t\t<td>S/N</td>\n\t\t\t<td>TEST</td>\n\t\t\t<td>OBSERVATION</td>\n\t\t\t<td>INFERENCE</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>1</td>\n\t\t\t<td>org. cmpd +<span class=\"math-tex\">\\( O_2 \\)</span>heat(combustion) + <span class=\"math-tex\">\\(Ca(OH)_2(aq)\\)</span> lime water&nbsp;</td>\n\t\t\t<td>Lime water turns milky</td>\n\t\t\t<td><span class=\"math-tex\">\\(CO_2\\)</span> evolves gas hence, the organic cmpd contains carbon(C)</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>2</td>\n\t\t\t<td>org. cmpd +<span class=\"math-tex\">\\( O_2 \\)</span>heat(combustion) + <span class=\"math-tex\">\\(CoCl_2\\)</span>(cobalt(II)chloride)&nbsp;</td>\n\t\t\t<td>\n\t\t\t<h3 style=\"font-style: italic;\"><span class=\"math-tex\">\\(CoCl_2\\)</span> changes colour from blue to pink&nbsp;</h3>\n\t\t\t</td>\n\t\t\t<td><span class=\"math-tex\">\\(H_2O\\)</span> is evolved, hence the org. cmpd contain Hydrogen(H)&nbsp;</td>\n\t\t</tr>\n\t</tbody>\n</table>\n\n<p>org. cmpd + Na + heat + water + filtration [Lassaigne&#39;s filtrate (LF) is obtained]&nbsp;</p>\n\n<table border=\"1\" bordercolor=\"#ccc\" cellpadding=\"5\" cellspacing=\"0\" style=\"border-collapse:collapse\">\n\t<tbody>\n\t\t<tr>\n\t\t\t<td>3</td>\n\t\t\t<td><span class=\"math-tex\">\\(LF + FeSO_4(aq) + FeCl_3(aq)\\)</span></td>\n\t\t\t<td>Prussian blue colouration of the solution&nbsp;</td>\n\t\t\t<td>Nitrogen(N) is confirmed&nbsp;</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>4</td>\n\t\t\t<td><span class=\"math-tex\">\\(LF + Pb(CH3COO)_2(aq) + H+\\)</span></td>\n\t\t\t<td>Black precipitate</td>\n\t\t\t<td>\n\t\t\t<h3>Sulphur(S) is confirmed</h3>\n\t\t\t</td>\n\t\t</tr>\n\t</tbody>\n</table>\n\n<p>TEST FOR HALIDES (F, Cl or I)</p>\n\n<table border=\"1\" bordercolor=\"#ccc\" cellpadding=\"5\" cellspacing=\"0\" style=\"border-collapse:collapse\">\n\t<tbody>\n\t\t<tr>\n\t\t\t<td>5</td>\n\t\t\t<td><span class=\"math-tex\">\\(LF + dil. HNO_3 + AgNO_3(aq)\\)</span></td>\n\t\t\t<td>\n\t\t\t<h3>(i) White precipitate soluble in excess ammonia solution&nbsp;<br />\n\t\t\t(ii) Pale yellow precipitate slightly soluble in excess ammonia solution&nbsp;<br />\n\t\t\t(iii) Yellow precipitate insoluble in excess ammonia solution&nbsp;</h3>\n\t\t\t</td>\n\t\t\t<td>Chlorine(Cl) is confirmed&nbsp;<br />\n\t\t\tBromine(Br) is confirmed&nbsp;&nbsp;<br />\n\t\t\tIodine(I) is confirmed&nbsp;</td>\n\t\t</tr>\n\t</tbody>\n</table>\n\n<p>From the question: Tests 1, 2 and 5 are positive. Thus the organic compound contain Carbon (C), Hydrogen (H) and Iodine (I)&nbsp;</p>\n\n<p>&nbsp;</p>
""";

// find and replace all spans with class math-tex with their children!
static String text = str.replaceAllMapped(RegExp(r'<span class=\\\"math-tex\\\"[^>]*>((.|\\n)*?)<\/span>'), (match) {
  return '${match.group(1)}';
  });

static Map module = jsonDecode(text);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CustomHtml(
          data: withImg,
          useRichText: false,
        ),
      ],
    );
  }
}
