import 'dart:ui';
import 'dart:typed_data';
import 'package:crop_image/crop_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:goltens_core/utils/functions.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_web/routes/routes.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  int currentPage = 1;
  int totalPages = 1;
  int limit = 50;
  bool isLoading = false;
  bool isError = false;
  String? search;
  Uint8List? croppedBytes;
  List<GetGroupsResponseData> groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getGroups(
        page: currentPage,
        limit: limit,
        search: search,
      );

      setState(() {
        groups = res.data;
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

  Future<GetGroupResponseData?> fetchGroup(int id) async {
    if (isLoading) return null;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getGroup(id: id);
      setState(() {
        isError = false;
        isLoading = false;
      });
      return res.data;
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        isError = true;
        isLoading = false;
      });

      return null;
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      setState(() => currentPage++);
      fetchGroups();
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      fetchGroups();
    }
  }

  Future<void> createGroup(String name) async {
    try {
      await AdminService.createGroup(
        name: name,
        byteArray: croppedBytes != null ? croppedBytes as List<int> : null,
        filename: 'avatar.jpg',
      );

      await fetchGroups();

      if (mounted) {
        const snackBar = SnackBar(content: Text('Group Created'));
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

  Future<void> updateGroup(
    int id,
    Uint8List? bytes,
    String name, {
    bool deleteAvatar = false,
  }) async {
    try {
      await AdminService.updateGroup(
        id: id,
        name: name,
        byteArray: bytes != null ? bytes as List<int> : null,
        filename: 'avatar.jpg',
        deleteAvatar: deleteAvatar,
      );

      await fetchGroups();

      if (mounted) {
        const snackBar = SnackBar(content: Text('Group Updated'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void showGroupEditDialog(GetGroupsResponseData group) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Update Group")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              var formKey = GlobalKey<FormState>();
              var nameTextController = TextEditingController(text: group.name);

              return SizedBox(
                height: 280,
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
                                      child: group.avatar?.isNotEmpty == true
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              child: Image.network(
                                                '$apiUrl/$groupsAvatar/${group.avatar}',
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
                                              group.name[0],
                                              style: const TextStyle(
                                                fontSize: 60.0,
                                              ),
                                            ),
                                    ),
                                    group.avatar?.isNotEmpty == true
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
                                                      updateGroup(
                                                        group.id,
                                                        null,
                                                        group.name,
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
                      const SizedBox(height: 16.0),
                      Form(
                        key: formKey,
                        child: TextFormField(
                          controller: nameTextController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter a name';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();
                            Navigator.pop(context);

                            updateGroup(
                              group.id,
                              croppedBytes,
                              nameTextController.text,
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Update Group')
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

                            outerSetState(() {
                              croppedBytes = data!.buffer.asUint8List();
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

  void showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        var formKey = GlobalKey<FormState>();
        var nameTextController = TextEditingController();

        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Create Group")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return SizedBox(
                height: 280,
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
                          child: CircleAvatar(
                            radius: 60.0,
                            child: croppedBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.memory(croppedBytes!),
                                  )
                                : const Text('Select Avatar'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Form(
                        key: formKey,
                        child: TextFormField(
                          controller: nameTextController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter a name';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();
                            Navigator.pop(context);
                            createGroup(nameTextController.text);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Create Group')
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

  Future<void> deleteGroup(GetGroupsResponseData group) async {
    try {
      var res = await AdminService.deleteGroup(groupId: group.id);

      if (mounted) {
        final snackBar = SnackBar(content: Text(res.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      await fetchGroups();
    }
  }

  void showDeleteGroupDialog(GetGroupsResponseData group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Are you sure you want to delete this group ${group.name} ?",
          ),
          actions: [
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                await deleteGroup(group);

                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
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
          title: const Center(child: Text("Search Groups")),
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

                              await fetchGroups();

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

                          await fetchGroups();

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Search Groups')
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

  Future<void> openGroup(GetGroupsResponseData group) async {
    var groupDetail = await fetchGroup(group.id);

    if (mounted) {
      navigateTo(
        routeName: '/admin/groups-detail',
        queryParams: {
          'group_id': groupDetail?.id,
        },
      );
    }
  }

  Widget buildBody() {
    var isMobile = MediaQuery.of(context).size.width < 600;

    if (groups.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Groups Available',
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
                DataColumn(label: Text('Members')),
                DataColumn(label: Text('Created At')),
                DataColumn(label: Text('Edit')),
                DataColumn(label: Text('Delete')),
                DataColumn(label: Text('View')),
              ],
              rows: groups.map((group) {
                var createdAt = formatDateTime(
                  group.createdAt,
                  'HH:mm dd/MM/y',
                );

                return DataRow(
                  cells: <DataCell>[
                    DataCell(
                      CircleAvatar(
                        radius: 16,
                        child: group.avatar?.isNotEmpty == true
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  '$apiUrl/$groupsAvatar/${group.avatar}',
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
                            : Text(group.name[0]),
                      ),
                      onTap: () => openGroup(group),
                    ),
                    DataCell(
                      Text(group.name),
                      onTap: () => openGroup(group),
                    ),
                    DataCell(
                      Text(group.members.length.toString()),
                      onTap: () => openGroup(group),
                    ),
                    DataCell(
                      Text(createdAt),
                      onTap: () => openGroup(group),
                    ),
                    DataCell(
                      IconButton(
                        onPressed: () => showGroupEditDialog(group),
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        onPressed: () => showDeleteGroupDialog(group),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        onPressed: () => openGroup(group),
                        icon: const Icon(Icons.arrow_right_outlined),
                      ),
                    )
                  ],
                );
              }).toList(),
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
            Text(
              '${totalPages == 0 ? 0 : currentPage} / $totalPages',
            ),
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
                                        : 'Groups',
                                    style: const TextStyle(fontSize: 28.0),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: showCreateGroupDialog,
                                    child: const SizedBox(
                                      width: 100,
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
                                    onPressed: showCreateGroupDialog,
                                    child: const SizedBox(
                                      width: 120,
                                      child: Row(
                                        children: [
                                          Icon(Icons.add),
                                          SizedBox(width: 5),
                                          Text('Create Group')
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
                                        : 'Groups',
                                    style: const TextStyle(fontSize: 32.0),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: showSearchDialog,
                                        icon: const Icon(Icons.search),
                                        label: const Text('Search'),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        onPressed: showCreateGroupDialog,
                                        icon: const Icon(Icons.add),
                                        label: const Text('Create Group'),
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
