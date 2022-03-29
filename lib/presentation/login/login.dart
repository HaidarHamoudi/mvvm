import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:mvvm/app/app_prefs.dart';
import 'package:mvvm/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:mvvm/presentation/login/login_viewmodel.dart';
import 'package:mvvm/presentation/resources/assets_manager.dart';
import 'package:mvvm/presentation/resources/color_manager.dart';
import 'package:mvvm/presentation/resources/values_manager.dart';
import '../../app/di.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  /*
  I will retrieve the instance of LoginViewModel from the instance of GetIt.
  */
  final LoginViewModel _viewModel = instance<LoginViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final TextEditingController _userNamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.start();
    // listener is for updating the username and the password in the view model
    _userNamecontroller
        .addListener(() => _viewModel.setUserName(_userNamecontroller.text));
    _passwordcontroller
        .addListener(() => _viewModel.setPassword(_passwordcontroller.text));
    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((token) {
      // navigate to main screen
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _appPreferences.setIsUserLoggedIn();
        _appPreferences.setToken(token);
        // Re-initialize the dependency injection to update the token
        resetAllModules();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.login();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p100),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Image(
                image: AssetImage(ImageAssets.splashLogo),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsUserNameValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userNamecontroller,
                      decoration: InputDecoration(
                          hintText: AppStrings.username.tr(),
                          labelText: AppStrings.username.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.usernameError.tr()),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsPasswordValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                          hintText: AppStrings.password.tr(),
                          labelText: AppStrings.password.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.passwordError.tr()),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsAllInputsValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () {
                                    _viewModel.login();
                                  }
                                : null,
                            child: const Text(AppStrings.login).tr()),
                      );
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p8,
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.forgetPasswordRoute);
                      },
                      child: Text(
                        AppStrings.forgetPassword,
                        style: Theme.of(context).textTheme.subtitle2,
                      ).tr(),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.registerRoute);
                      },
                      child: Text(
                        AppStrings.registerText,
                        style: Theme.of(context).textTheme.subtitle2,
                      ).tr(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
