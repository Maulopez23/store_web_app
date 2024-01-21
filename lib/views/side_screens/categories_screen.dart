import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:store_web_app/views/side_screens/widgets/category_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  static const String screenRoute = "CategoriesScreen";

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  
  dynamic _image;
  String? _fileName;
  late String _categoryName;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image
    );

    if(result != null) {
      setState(() {
        _image = result.files.first.bytes;
        _fileName = result.files.first.name;
      });
    }
  }

  _uploadCategoryBannerToFirebaseStorage(dynamic image) async {
    var ref = _firebaseStorage.ref().child('categoryImages').child(_fileName!);

    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  _uploadCategoryBannerToFirestore() async {
    EasyLoading.show();
    if(_formKey.currentState!.validate()) {
      var imageURL = await _uploadCategoryBannerToFirebaseStorage(_image);
      await _firebaseFirestore.collection("categories").doc(_fileName).set({
        'image': imageURL,
        'categories': _categoryName
      }).whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _image = null;
        });
      });
    } else {
    }   
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Categories Management',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Row(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _image != null ? Image.memory(_image, 
                      fit: BoxFit.cover,)
                      : const Text('Upload Category')
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        onChanged: (value) {
                          _categoryName = value;
                        },
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Please the Category Name must not be empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Enter category name',
                          hintText: 'Enter category name', 
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _uploadCategoryBannerToFirestore();
                    }, 
                    child: const Text('Save Category')
                  ),
                  
                ],
              ),
              const SizedBox(
                height: 30,
              ),         
              ElevatedButton(
                onPressed: () {
                  pickImage();
                }, 
                child: const Text('Select Category')
              ),
              const SizedBox(
                height: 30,
              ),  
              const CategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}