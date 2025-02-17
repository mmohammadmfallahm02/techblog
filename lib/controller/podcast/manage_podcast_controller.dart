import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tec/constant/api_constant.dart';
import 'package:tec/constant/api_key_constants.dart';
import 'package:tec/constant/commands.dart';
import 'package:tec/controller/file_controller.dart';
import 'package:tec/models/podcast_model.dart';
import 'package:tec/models/podcasts_file_model.dart';
import 'package:tec/services/dio_service.dart';
import '../../constant/storage_const.dart';

class ManagePodcastController extends GetxController {
  RxList<PodcastModel> podcastModel = RxList.empty();

  Rx<PodcastsFileModel> podcastFileModel =
      PodcastsFileModel("اسم پادکست اینجا قرار میگیره").obs;

  // var selectedTime = TimeOfDay.now().replacing(hour: 0,minute: 0).obs;
  RxBool loading = false.obs;
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController titleTextEditingControllerHour =
      TextEditingController();
  TextEditingController titleTextEditingControllerMinute =
      TextEditingController();

  RxInt? input = 0.obs;
  RxInt? inputHoure = 0.obs;
  RxBool isvisibleMinute = false.obs;
  RxBool isvisibleHour = false.obs;
  var userId = '';
  var catId = '';

  updateTitle() {
    podcastFileModel.update((val) {
      val!.title = titleTextEditingController.text;
    });
  }

  titlePodcast() async {
    loading.value = true;
    Map<String, dynamic> map = {
      ApiPodcastTitleKyConstants.userId: GetStorage().read(StorageKey.userId),
      ApiPodcastTitleKyConstants.catId: catId,
      ApiPodcastTitleKyConstants.title: titleTextEditingController.text,
      ApiPodcastTitleKyConstants.command: Commands.storTitle,
    };
    var response =
        await DioService().postMethod(map, ApiUrlConstant.postPodcast);
    if (response.statusCode == 200) {
      SnackBar(
        content: Text("با موفقیت انجام شد"),
      );
    }
    loading.value = false;
  }

  filePodcast() async {
    var fileController = Get.find<FilePickerController>();
    loading.value = true;
    Map<String, dynamic> map = {
      ApiPodcastFileKyConstants.title: podcastFileModel.value.title,
      ApiPodcastFileKyConstants.file:
          await dio.MultipartFile.fromFile(fileController.file.value.path!),
      ApiPodcastFileKyConstants.podcastId: podcastFileModel.value.podcastId,
      ApiPodcastFileKyConstants.command: Commands.storFile,
      ApiPodcastFileKyConstants.length: podcastFileModel.value.lenght,
    };
    var response =
        await DioService().postMethod(map, ApiUrlConstant.postPodcast);
  }

  UpdatePodcast() async {
    var fileController = Get.find<FilePickerController>();
    loading.value = true;
    Map<String, dynamic> map = {
      ApiPodcastUpdateKyConstants.image:
          await dio.MultipartFile.fromFile(fileController.file.value.path!),
      ApiPodcastUpdateKyConstants.file: podcastFileModel.value.file,
      ApiPodcastUpdateKyConstants.podcastId: podcastFileModel.value.podcastId,
      ApiPodcastUpdateKyConstants.command: Commands.storUpdate,
      ApiPodcastUpdateKyConstants.userId: GetStorage().read(StorageKey.userId),
    };
    var response =
        await DioService().postMethod(map, ApiUrlConstant.postPodcast);
  }
}
