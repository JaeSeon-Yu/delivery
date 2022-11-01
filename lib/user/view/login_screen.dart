import 'dart:convert';
import 'dart:io';

import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    const emulatorIp = 'http://10.0.2.2:3000';
    const simulatorIp = 'http://127.0.0.1:3000';

    final ip = Platform.isAndroid ? emulatorIp : simulatorIp;

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(
                  height: 16,
                ),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final rawString = '$username:$password';
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post(
                      '$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );
                    
                    final refrechToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];
                    
                    await storage.write(key: REFRESH_TOKEN_KEY, value: refrechToken);
                    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RootTab()),
                    );
                    Logger().i(resp.data);
                  },
                  child: const Text('로그인'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  onPressed: () async {
                    final resp = await dio.post(
                      '$ip/auth/token',
                      options: Options(
                        headers: {
                          'authorization': 'Bearer ${storage.read(key: REFRESH_TOKEN_KEY)}',
                        },
                      ),
                    );

                    storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);
                  },
                  child: const Text('회원가입'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다 !',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 34,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
