import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_web/components/user_communication_drawer.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserResponse? user;
  late Widget avatarPicture;

  @override
  void initState() {
    super.initState();

    final state = context.read<GlobalState>();

    avatarPicture = Image.network(
      '$apiUrl/$avatar/${state.user?.data.avatar}',
      errorBuilder: (
        context,
        obj,
        stacktrace,
      ) {
        return Container();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() => user = state.user);
      }
    });
  }

  Future<void> updateDetails({
    required String name,
    required String phone,
    required String email,
    required String department,
    required String employeeNumber,
  }) async {
    try {
      var res = await AuthService.updateDetails(
        name: name,
        phone: phone,
        email: email,
        department: department,
        employeeNumber: employeeNumber,
      );

      var userResponse = await AuthService.getMe();
      setState(() => user = userResponse);

      if (mounted) {
        final snackBar = SnackBar(content: Text(res.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.read<GlobalState>().setUserResponse(userResponse);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await AuthService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      var userResponse = await AuthService.getMe();
      setState(() => user = userResponse);

      if (mounted) {
        const snackBar = SnackBar(
          content: Text('Password Changed Successfully'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.read<GlobalState>().setUserResponse(userResponse);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        var formKey = GlobalKey<FormState>();
        final currentPasswordTextController = TextEditingController();
        final newPasswordTextController = TextEditingController();
        bool showPassword = false;

        return AlertDialog(
          title: const Center(child: Text("Change Password")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return SizedBox(
                height: 215,
                width: 410,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Current Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    !showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(
                                    () => showPassword = !showPassword,
                                  ),
                                ),
                              ),
                              controller: currentPasswordTextController,
                              obscureText: !showPassword,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter new password';
                                }

                                if (value != null && value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    !showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(
                                    () => showPassword = !showPassword,
                                  ),
                                ),
                              ),
                              controller: newPasswordTextController,
                              obscureText: !showPassword,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter new password';
                                }

                                if (value != null && value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.done),
                        label: const Text('Change Password'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();

                            changePassword(
                              currentPasswordTextController.text,
                              newPasswordTextController.text,
                            );

                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> chooseAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    var filename = result?.files.first.name;
    var bytes = result?.files.first.bytes;
    if (!mounted) return;

    if (bytes != null) {
      final controller = CropController(
        aspectRatio: 1,
        defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(left: 25, right: 25),
            title: const Center(child: Text("Crop Avatar")),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: StatefulBuilder(
              builder: (
                BuildContext context,
                StateSetter setState,
              ) {
                return SizedBox(
                  height: 400,
                  width: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        CropImage(
                          controller: controller,
                          image: Image.memory(bytes),
                          gridColor: Colors.white,
                          gridCornerSize: 50,
                          gridThinWidth: 3,
                          gridThickWidth: 6,
                          scrimColor: Colors.black,
                          alwaysShowThirdLines: true,
                          minimumImageSize: 500,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () async {
                            var bitmap = await controller.croppedBitmap();

                            var data = await bitmap.toByteData(
                              format: ImageByteFormat.png,
                            );

                            var croppedBytes = data!.buffer.asUint8List();

                            await uploadAvatar(
                              croppedBytes,
                              filename ?? 'image.jpg',
                            );

                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.done),
                          label: const Text('Done'),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  Future<void> uploadAvatar(
    List<int>? file,
    String filename,
  ) async {
    try {
      var res = await AuthService.updateAvatar(
        byteArray: file,
        filename: filename,
      );

      var userResponse = await AuthService.getMe();
      setState(() => user = userResponse);

      if (mounted) {
        final snackBar = SnackBar(content: Text(res.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.read<GlobalState>().setUserResponse(userResponse);
      }
    } catch (err) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(err.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> deleteAvatar() async {
    try {
      await AuthService.updateAvatar(localFilePath: null);
      var userResponse = await AuthService.getMe();
      setState(() => user = userResponse);

      if (mounted) {
        const snackBar = SnackBar(content: Text('Avatar Deleted'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.read<GlobalState>().setUserResponse(userResponse);
      }
    } catch (err) {
      if (!mounted) return;
      final snackBar = SnackBar(content: Text(err.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return Container();

    final nameTextController = TextEditingController(
      text: user?.data.name,
    );

    final emailTextController = TextEditingController(
      text: user?.data.email,
    );

    final phoneTextController = TextEditingController(
      text: user?.data.phone,
    );

    final departmentController = SingleValueDropDownController(
      data: DropDownValueModel(
        name: user?.data.department ?? '',
        value: user?.data.department,
      ),
    );

    final employeeNumberTextController = TextEditingController(
      text: user?.data.employeeNumber,
    );

    var isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        title: Text('Communication Page'),
      )
          : null,
      drawer: isMobile ? UserCommunicationDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) const UserCommunicationDrawer(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(60),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(60.0),
                                onTap: chooseAvatar,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  child: user?.data.avatar.isNotEmpty == true
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image.network(
                                            '$apiUrl/$avatar/${user?.data.avatar}',
                                            errorBuilder: (
                                              context,
                                              obj,
                                              stacktrace,
                                            ) {
                                              return Container();
                                            },
                                          ),
                                        )
                                      : Text(
                                          user?.data.name[0] ?? '---',
                                          style: const TextStyle(
                                            fontSize: 60.0,
                                          ),
                                        ),
                                ),
                              ),
                              user?.data.avatar.isNotEmpty == true
                                  ? Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: IconButton(
                                              icon: const Icon(Icons.delete),
                                              iconSize: 24,
                                              onPressed: () {
                                                deleteAvatar();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          user?.data.name ?? '---',
                          style: const TextStyle(fontSize: 28.0),
                        ),
                        const SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: SizedBox(
                            width: 800.0,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              controller: nameTextController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter your name';
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: SizedBox(
                            width: 800.0,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              controller: emailTextController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter your email address';
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: SizedBox(
                            width: 800.0,
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              initialValue: phoneTextController.text,
                              onChanged: (phone) {
                                phoneTextController.text = phone.completeNumber;
                              },
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value != null &&
                                    value.completeNumber.isEmpty) {
                                  return 'Please enter your phone number';
                                }

                                try {
                                  value?.isValidNumber();
                                  return null;
                                } on Exception {
                                  return 'Invalid Number';
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: SizedBox(
                            width: 800.0,
                            child: DropDownTextField(
                              clearOption: false,
                              controller: departmentController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please select your department';
                                }
                                return null;
                              },
                              textFieldDecoration: InputDecoration(
                                labelText: 'Department',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              dropDownItemCount: departmentList.length,
                              dropDownList: departmentList.map((department) {
                                return DropDownValueModel(
                                  name: department,
                                  value: department,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: SizedBox(
                            width: 800.0,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: 'Employee Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              controller: employeeNumberTextController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter your employee number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300.0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ElevatedButton.icon(
                              onPressed: showChangePasswordDialog,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                minimumSize: const Size(
                                  double.infinity,
                                  40.0,
                                ),
                              ),
                              icon: const Icon(Icons.edit),
                              label: const Text('Change Password'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300.0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: ElevatedButton.icon(
                              onPressed: () => updateDetails(
                                name: nameTextController.text,
                                email: emailTextController.text,
                                phone: phoneTextController.text,
                                department:
                                    departmentController.dropDownValue?.value,
                                employeeNumber:
                                    employeeNumberTextController.text,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                minimumSize: const Size(
                                  double.infinity,
                                  40.0,
                                ),
                              ),
                              icon: const Icon(Icons.done),
                              label: const Text('Update Details'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
