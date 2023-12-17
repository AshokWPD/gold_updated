import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  int currentPage = 1;
  int totalPages = 1;
  int limit = 50;
  bool isLoading = false;
  bool isError = false;
  String? search;
  Uint8List? croppedBytes;
  List<GetUsersResponseData> users = [];
  List<int> selectedUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getUsers(
        page: currentPage,
        limit: limit,
        search: search,
      );

      setState(() {
        users = res.data;
        isError = false;
        isLoading = false;
        totalPages = res.totalPages;
      });
    } catch (err) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      setState(() => currentPage++);
      fetchUsers();
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      fetchUsers();
    }
  }

  void deleteUsers() async {
    try {
      await AdminService.deleteUsers(userIds: selectedUsers);

      if (mounted) {
        const snackBar = SnackBar(content: Text('Users Deleted'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      await fetchUsers();
      setState(() => selectedUsers = []);
    }
  }

  Future<void> createUser(
    String name,
    String email,
    String password,
    String phone,
    String department,
    String employeeNumber,
  ) async {
    try {
      await AdminService.createUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        department: department,
        employeeNumber: employeeNumber,
        byteArray: croppedBytes != null ? croppedBytes as List<int> : null,
        filename: 'avatar.jpg',
        type: UserType.user,
      );

      await fetchUsers();

      if (mounted) {
        const snackBar = SnackBar(content: Text('User Created'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      croppedBytes = null;
    }
  }

  Future<void> updateUser(
    int id,
    String name,
    String email,
    String? password,
    String phone,
    String department,
    String employeeNumber,
    bool active,
    Uint8List? bytes, {
    bool deleteAvatar = false,
  }) async {
    try {
      await AdminService.updateUser(
        id: id,
        name: name,
        email: email,
        password: password,
        phone: phone,
        department: department,
        employeeNumber: employeeNumber,
        active: active,
        byteArray: bytes != null ? bytes as List<int> : null,
        filename: 'avatar.jpg',
        deleteAvatar: deleteAvatar,
      );

      await fetchUsers();

      if (mounted) {
        const snackBar = SnackBar(content: Text('User Updated'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      setState(() => croppedBytes = null);
    }
  }

  Future<void> chooseAvatar(StateSetter outerSetState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

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
                  height: 560,
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

                            outerSetState(() {
                              croppedBytes = data?.buffer.asUint8List();
                            });

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
                        )
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

  void showEditUserDialog(GetUsersResponseData user) {
    showDialog(
      context: context,
      builder: (context) {
        var formKey = GlobalKey<FormState>();

        var nameTextController = TextEditingController(
          text: user.name,
        );

        var emailTextController = TextEditingController(
          text: user.email,
        );

        var passwordTextController = TextEditingController(
          text: '',
        );

        var phoneTextController = TextEditingController(
          text: user.phone,
        );

        var departmentController = SingleValueDropDownController(
          data: DropDownValueModel(
            name: user.department,
            value: user.department,
          ),
        );

        var employeeNumberTextController = TextEditingController(
          text: user.employeeNumber,
        );

        int? selectedActiveIndex = user.active == true ? 0 : 1;
        bool showPasswordText = false;

        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Edit User")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return SizedBox(
                height: 500,
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(60),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(60.0),
                          onTap: () async {
                            await chooseAvatar(setState);
                          },
                          child: croppedBytes != null
                              ? CircleAvatar(
                                  radius: 60.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.memory(croppedBytes!),
                                  ),
                                )
                              : Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    CircleAvatar(
                                      radius: 60.0,
                                      child: user.avatar?.isNotEmpty == true
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              child: Image.network(
                                                '$apiUrl/$avatar/${user.avatar}',
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
                                              user.name[0],
                                              style: const TextStyle(
                                                fontSize: 60.0,
                                              ),
                                            ),
                                    ),
                                    user.avatar?.isNotEmpty == true
                                        ? Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: Container(
                                                width: 38,
                                                height: 38,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                    ),
                                                    iconSize: 24,
                                                    onPressed: () {
                                                      updateUser(
                                                        user.id,
                                                        user.name,
                                                        user.email,
                                                        null,
                                                        user.phone,
                                                        user.department,
                                                        user.employeeNumber,
                                                        user.active,
                                                        null,
                                                        deleteAvatar: true,
                                                      );

                                                      Navigator.pop(context);
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
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameTextController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter name';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailTextController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter email';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              obscureText: !showPasswordText,
                              controller: passwordTextController,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    !showPasswordText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(
                                    () => showPasswordText = !showPasswordText,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return null;
                                }

                                if (value != null && value.length < 6) {
                                  return 'Password must be atleast 6 characters long';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            IntlPhoneField(
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
                            const SizedBox(height: 16.0),
                            DropDownTextField(
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
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: employeeNumberTextController,
                              decoration: InputDecoration(
                                labelText: 'Employee Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter employee number';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Radio<int>(
                                  value: 0,
                                  groupValue: selectedActiveIndex,
                                  onChanged: (val) {
                                    setState(() => selectedActiveIndex = val);
                                  },
                                ),
                                const Text('Active'),
                                Radio<int>(
                                  value: 1,
                                  groupValue: selectedActiveIndex,
                                  onChanged: (val) {
                                    setState(() => selectedActiveIndex = val);
                                  },
                                ),
                                const Text('InActive'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();
                            Navigator.pop(context);
                            updateUser(
                              user.id,
                              nameTextController.text,
                              emailTextController.text,
                              passwordTextController.text,
                              phoneTextController.text,
                              departmentController.dropDownValue?.value,
                              employeeNumberTextController.text,
                              selectedActiveIndex == 0 ? true : false,
                              croppedBytes,
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Update User')
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

  void makeUsersAsUserAndSubAdmins() async {
    try {
      await AdminService.makeUsersAsUserAndSubAdmins(
        userIds: selectedUsers,
      );

      if (mounted) {
        const snackBar = SnackBar(
          content: Text(
            'Users are now User & SubAdmins!',
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      fetchUsers();
      setState(() => selectedUsers = []);
    }
  }

  void makeUsersAsSubAdmins() async {
    try {
      await AdminService.makeUsersAsSubAdmins(
        userIds: selectedUsers,
      );

      if (mounted) {
        const snackBar = SnackBar(content: Text('Users are now SubAdmin!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      fetchUsers();
      setState(() => selectedUsers = []);
    }
  }

  void showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        var formKey = GlobalKey<FormState>();
        var nameTextController = TextEditingController();
        var emailTextController = TextEditingController();
        var passwordTextController = TextEditingController();
        var phoneTextController = TextEditingController();
        var departmentController = SingleValueDropDownController();
        var employeeNumberTextController = TextEditingController();
        bool showPassword = false;

        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Create User")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return SizedBox(
                height: 560,
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(60),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(60.0),
                              onTap: () => chooseAvatar(setState),
                              child: CircleAvatar(
                                radius: 60.0,
                                child: croppedBytes != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: Image.memory(croppedBytes!),
                                      )
                                    : const Text('Select Avatar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameTextController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter name';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailTextController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter email';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              obscureText: !showPassword,
                              controller: passwordTextController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter password';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
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
                            ),
                            const SizedBox(height: 16.0),
                            IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              initialValue: phoneTextController.text,
                              initialCountryCode: singaporeCountryCode,
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
                            const SizedBox(height: 16.0),
                            DropDownTextField(
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
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: employeeNumberTextController,
                              decoration: InputDecoration(
                                labelText: 'Employee Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter employee number';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();
                            Navigator.pop(context);

                            createUser(
                              nameTextController.text,
                              emailTextController.text,
                              passwordTextController.text,
                              phoneTextController.text,
                              departmentController.dropDownValue?.value,
                              employeeNumberTextController.text,
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Create User')
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Search Users")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              var searchTextController = TextEditingController(text: search);

              return SizedBox(
                height: 150,
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: searchTextController,
                        decoration: InputDecoration(
                          labelText: 'Search...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              setState(() {
                                search = null;
                                currentPage = 1;
                              });

                              await fetchUsers();

                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (searchTextController.text.isEmpty) {
                            const snackBar = SnackBar(
                              content: Text(
                                'Enter something to search for...,',
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBar,
                            );

                            return;
                          }

                          setState(() {
                            search = searchTextController.text;
                            currentPage = 1;
                          });

                          await fetchUsers();

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Search Users')
                          ],
                        ),
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

  Widget buildBody() {
    var isMobile = MediaQuery.of(context).size.width < 600;

    if (users.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Users Available',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 15),
        SizedBox(
          height: isMobile
              ? MediaQuery.of(context).size.height / 3
              : MediaQuery.of(context).size.height / 1.5,
          child: ScrollableDataTable(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Avatar')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Admin Approved')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Active')),
                DataColumn(label: Text('Edit')),
              ],
              rows: users
                  .map(
                    (user) => DataRow(
                      cells: <DataCell>[
                        DataCell(
                          CircleAvatar(
                            radius: 16,
                            child: user.avatar?.isNotEmpty == true
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.network(
                                      '$apiUrl/$avatar/${user.avatar}',
                                      fit: BoxFit.contain,
                                      height: 500,
                                      width: 500,
                                      errorBuilder: (
                                        context,
                                        obj,
                                        stacktrace,
                                      ) {
                                        return Container();
                                      },
                                    ),
                                  )
                                : Text(user.name[0]),
                          ),
                        ),
                        DataCell(Text(user.name)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.phone)),
                        DataCell(Text(user.department)),
                        DataCell(Text(user.adminApproved.name)),
                        DataCell(Text(user.type.name)),
                        DataCell(Text(user.active ? 'Yes' : 'No')),
                        DataCell(
                          IconButton(
                            onPressed: () => showEditUserDialog(user),
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ],
                      selected: selectedUsers.contains(user.id),
                      onSelectChanged: (isItemSelected) {
                        setState(() {
                          if (isItemSelected == true) {
                            selectedUsers.add(user.id);
                          } else {
                            selectedUsers.remove(user.id);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: currentPage == 1 ? null : prevPage,
              splashRadius: 15.0,
            ),
            Text('${totalPages == 0 ? 0 : currentPage} / $totalPages'),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: currentPage == totalPages ? null : nextPage,
              splashRadius: 15.0,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        title: Text('Admin Page'),
      )
          : null,
      drawer: isMobile ? AdminDrawer() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: selectedUsers.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 20.0 : 32.0,
                horizontal: isMobile ? 16.0 : 50.0,
              ),
              child: isMobile
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 15.0),
                        ElevatedButton(
                          onPressed: makeUsersAsUserAndSubAdmins,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.manage_accounts),
                              SizedBox(width: 5),
                              Text('Make Both User & SubAdmin')
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        ElevatedButton(
                          onPressed: makeUsersAsSubAdmins,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.manage_accounts),
                              SizedBox(width: 5),
                              Text('Make SubAdmin Only')
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        ElevatedButton(
                          onPressed: deleteUsers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 5),
                              Text('Delete Users')
                            ],
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: makeUsersAsUserAndSubAdmins,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.manage_accounts),
                              SizedBox(width: 5),
                              Text('Make Both User & SubAdmin')
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: makeUsersAsSubAdmins,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.manage_accounts),
                              SizedBox(width: 5),
                              Text('Make SubAdmin Only')
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: deleteUsers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 5),
                              Text('Delete Users')
                            ],
                          ),
                        )
                      ],
                    ),
            )
          : Container(),
      body: Row(
        children: [
          if (!isMobile) const AdminDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: isLoading
                    ? [const CircularProgressIndicator()]
                    : [
                        isMobile
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    search?.isNotEmpty == true
                                        ? 'Results for "$search"'
                                        : 'Users',
                                    style: const TextStyle(fontSize: 28.0),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: showSearchDialog,
                                    child: const SizedBox(
                                      width: 80,
                                      child: Row(
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(width: 5),
                                          Text('Search')
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: showCreateUserDialog,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 110,
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.add),
                                          SizedBox(width: 5),
                                          Text('Create User')
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    search?.isNotEmpty == true
                                        ? 'Results for "$search"'
                                        : 'Users',
                                    style: const TextStyle(fontSize: 32.0),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      ElevatedButton.icon(
                                        onPressed: showSearchDialog,
                                        icon: const Icon(Icons.search),
                                        label: const Text('Search'),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        onPressed: showCreateUserDialog,
                                        icon: const Icon(Icons.add),
                                        label: const Text('Create User'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        buildBody(),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
