import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Constants.dart';
import '../ServiceLocator.dart';

class TermsServicePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextStyle _headerTextStyle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.bold,
  );

  final TextStyle _paragraphTextStyle = TextStyle(
    fontSize: 18,
  );

  final SizedBox _space = SizedBox(
    height: 30,
  );
  final SizedBox _smallSpace = SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Terms & Services',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              _smallSpace,
              Text(
                'Intellectual Property',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'You acknowledge that we or our licensors retain all proprietary right, title, and interest in the Services, our name, logo, or other marks, and any related intellectual property right, including, without limitation, all modifications, enhancements, derivative works, and upgrades thereto. You agree that you will not use or register any trademark, service mark, business name, domain name or social media account name or is similar to any of these.',
                style: _paragraphTextStyle,
              ),
              _space,
              Text(
                'User-Generated Content',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'The Services may contain information, text, links, graphic, photos, videos, or other materials(“Content”), including Content created with or submitted to the Services by you or through your Account(“Your Content”). We take no responsibility for and we do not expressly or implicit endorse any of Your Content.  By submitting Your Content to the Services, you represent and warrant that you have all right, power, and authority necessary to grant the rights to Your Content contained within these Terms. Because you. Alone are responsible for Your Content, you may expose yourself to liability if you post or share Content without all necessary rights.',
                style: _paragraphTextStyle,
              ),
              _space,
              Text(
                'Prohibited Uses',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'By used our Services, you agree on behalf of yourself, your users, and your attendees, not to (1) modify, prepare derivative works of, or reverse engineer, our Services; (2) knowingly use our Services in a way that abuses our networks, user accounts, or the Services; (3) transmit through the Services any harassing, indecent, obscene, fraudulent, or unlawful material; (4) market, or resell the Services to any third party; (5) use the Services in violation of applicable laws, or regulations; (6) use the Services to send unauthorized advertising, or spam; (7) harvest, collect, or gather user data without their consent; or (8) transmit through the Services any material that my infringe the intellectual property, privacy, or other rights of their parties.',
                style: _paragraphTextStyle,
              ),
              _space,
              Text(
                'Limitation of Liability',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'You agree that Critic shall, in no event, be liable for any consequential, incidental, indirect, special, punitive, or other loss or damage whatsoever or for loss of business profits, business interruption, computer failure, loss of business information, or other loss arising out of or caused by your use of inability to use the service, even if Critic has been advised of the possibility of such damage. In no event shall Critic’s entire liability to you in respect of any service, whether direct or indirect, exceed the fees paid by you towards such service.',
                style: _paragraphTextStyle,
              ),
              _space,
              Text(
                'Right to Terminate Accounts',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'If you fail, or Critic suspects on reasonable grounds that you have failed, to comply with any of the provisions of this Agreement, Critic may, without notice to you: (1) terminate this Agreement; and/or (2) terminate your license to the software; and/or (3) preclude your access to the Services.',
                style: _paragraphTextStyle,
              ),
              _space,
              Text(
                'Governing Law and Jurisdiction',
                style: _headerTextStyle,
              ),
              _smallSpace,
              Text(
                'These Terms of Service are governed by the laws of Ohio, and all parties submit to the non-exclusive jurisdiction of the courts of this State.',
                style: _paragraphTextStyle,
              ),
              _space,
            ],
          ),
        ),
      ),
    );
  }
}
