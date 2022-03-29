import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvvm/data/mapper/mapper.dart';
import 'package:mvvm/presentation/common/state_renderer/state_rendere_impl.dart';
import 'package:mvvm/presentation/register/register_viewmodel.dart';
import 'package:mvvm/presentation/resources/color_manager.dart';
import 'package:mvvm/presentation/resources/values_manager.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  ImagePicker picker = instance<ImagePicker>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNametextEditingController =
      TextEditingController();
  final TextEditingController _mobileNumbertextEditingController =
      TextEditingController();
  final TextEditingController _emailtextEditingController = TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _viewModel.start();
    _userNametextEditingController.addListener(() {
      _viewModel.setUserName(_userNametextEditingController.text);
    });
    _passwordtextEditingController.addListener(() {
      _viewModel.setPassword(_passwordtextEditingController.text);
    });
    _emailtextEditingController.addListener(() {
      _viewModel.setEmail(_emailtextEditingController.text);
    });
    _mobileNumbertextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumbertextEditingController.text);
    });
    _viewModel.isUserRegisteredSuccessfullyStreamController.stream
        .listen((isSuccessLoggedIn) {
      // navigate to main screen
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _appPreferences.setIsUserLoggedIn();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        iconTheme: IconThemeData(color: ColorManager.primary),
        backgroundColor: ColorManager.white,
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return Center(
            child: snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.register();
                }) ??
                _getContentWidget(),
          );
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p30),
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
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorUserName,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _userNametextEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.username.tr(),
                        labelText: AppStrings.username.tr(),
                        errorText: snapshot.data,
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppPadding.p20,
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                    bottom: AppPadding.p12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: CountryCodePicker(
                            onChanged: (countryMobileCode) {
                              // update viewmodel with the selected code
                              _viewModel.setCountryMobileCode(
                                  countryMobileCode.dialCode ?? EMPTY);
                            },
                            initialSelection: "+963",
                            showCountryOnly: true,
                            hideMainText: true,
                            showOnlyCountryWhenClosed: true,
                            favorite: const [
                              "+971",
                              "+33",
                              "+961",
                            ],
                          )),
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<String?>(
                          stream: _viewModel.outputErrorMobileNumber,
                          builder: (context, snapshot) {
                            return TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _mobileNumbertextEditingController,
                              decoration: InputDecoration(
                                hintText: AppStrings.mobileNumber.tr(),
                                labelText: AppStrings.mobileNumber.tr(),
                                errorText: snapshot.data,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s12),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorEmail,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailtextEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.emailHint.tr(),
                        labelText: AppStrings.emailHint.tr(),
                        errorText: snapshot.data,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSize.s12),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p12,
                    left: AppPadding.p28, right: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorPassword,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordtextEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.password.tr(),
                        labelText: AppStrings.password.tr(),
                        errorText: snapshot.data,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSize.s12),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p12,
                    left: AppPadding.p28, right: AppPadding.p28),
                child: Container(
                  height: AppSize.s40,
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.lightGrey)),
                  child: GestureDetector(
                    child: _getMediaWidget(),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
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
                                    _viewModel.register();
                                  }
                                : null,
                            child: const Text(AppStrings.register).tr()),
                      );
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p8,
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.haveAccount,
                    style: Theme.of(context).textTheme.subtitle2,
                  ).tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: const Text(AppStrings.profilePicture).tr(),
          ),
          Flexible(
            child: StreamBuilder<File?>(
              stream: _viewModel.outputProfilePicture,
              builder: (context, snapshot) {
                return _imagePickedByUser(snapshot.data);
              },
            ),
          ),
          Flexible(
            child: SvgPicture.asset(ImageAssets.photoCameraIc),
          ),
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: const Text(AppStrings.photoGallery).tr(),
                onTap: () {
                  _imageFromGalley();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text(AppStrings.photoCamera).tr(),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }

  _imageFromGalley() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
