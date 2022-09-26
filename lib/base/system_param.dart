import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

abstract class SystemParam {
  // static String baseUrl = "https://wrkpln-be.greenhcm.com/api/"; /*PRODUCTION*/
  // static String baseUrl = "https://workplan-be.aplikasidev.com/api/"; /* DEV */
  static String baseUrl = "https://hci-demo-be.aplikasidev.com/api/"; // UAT untuk HSI
  // static String baseUrl = "https://workplan-app-uat.dev-v3.aplikasidev.com/api/"; /* UAT https */
  // static String baseUrl = "https://workplan-app-beta.dev-v3.aplikasidev.com/api/"; // wrkpln-BETA

  static String fLogin = "login";
  static String fLoginByUserIdOrEmail = "login_by_userid_or_email";
  static String fWorkplanInbox = "workplan_inbox";
  static String fUpdateUserToken = "update_user_token";
  static String fResetPassword = "reset_password";
  static String fWorkplanInboxByUserCompanyId =
      "workplan_inbox_by_user_company_id";
  static String fWorkplanInboxUpdateList = "workplan_inbox_update_list";
  static String fWorkplanPersonalUpdateList = "workplan_personal_update_list";
  static String fWorkplanProdukUpdateList = "workplan_produk_update_list";
  static String fWorkplanUdfUpdateList = "workplan_udf_update_list";
  static String fWorkplanCreateList = "workplan_create_list";
  static String fWorkplanList = "workplan_list";
  static String fWorkplanListByUserCompanyId =
      "workplan_list_by_user_company_id";
  static String fWorkplanListByUserCompanyIdNew =
      "workplan_list_by_user_company_id_new";
  static String fWorkplanListAll = "workplan_list_all";
  static String fWorkplanById = "workplan_by_id";
  static String fWorkplanPersonalUpdate = "workplan_personal_update";
  static String fWorkplanProdukUpdate = "workplan_produk_update";
  static String fWorkplanInboxUpdate = "workplan_inbox_update";
  static String fWorkplanCreate = "workplan_create";
  static String fWorkplanCreateNew = "workplan_create_new";
  static String fWorkplanVisitList = "workplan_visit_list";
  static String fWorkplanVisitUpdateList = "visit_update_list";
  static String fWorkplanVisitListByUserId = "workplan_visit_list_by_user_id";
  static String fVisitCheckIn = "visit_check_in";
  static String fVisitResultUpdate = "visit_result_update";
  static String fVisitInsert = "visit_insert";
  // static String fParameterByType = "parameter_by_type";
  static String fParameterByTypeCompanyId = "parameter_by_type_company_id";
  static String fParameter = "parameter";
  static String fRegionByType = "region_by_type";
  static String fRegionKabKota = "region_by_type_and_parent_id";
  static String fParameterProgresStatus = "parameter_progres_status";
  static String progresStatusCodeNew = 'PS001';
  static String progresStatusCodeFollowUp = 'PS002';
  static String progresStatusCodeDrop = 'PS003';
  static String progresStatusCodeReject = 'PS004';
  static String progresStatusCodeDone = 'PS005';

  static String parameterTypeGender = "GENDER";
  static String parameterTypeReligion = "RELIGION";
  static String parameterTypeMaritalStatus = "MARITAL_STATUS";
  static String parameterTypeNationality = "NATIONALITY";
  static String parameterTypeBlood = "BLOOD_GROUP";
  static String parameterTypeEducationType = "EDUCATION_TYPE";
  static String parameterTypeLanguageType = "LANGUAGE_TYPE";
  static String parameterTypeSessionTimeOut = "TIMEOUT_SAME_LOGIN";
  // static String parameterCodeSmsGatewayAPI ="SMS_GATEWAY_API";
  // static String parameterCodeSmsGatewayUserKey ="SMS_GATEWAY_USER_KEY";
  // static String parameterCodeSmsGatewayPassKey ="SMS_GATEWAY_USER_KEY";
  // static String parameterCodeTokenUrl = "TOKEN_URL";

  // static String smsGatewayAPIDefault ="https://gsm.zenziva.net/api/sendWA/###";
  // static String smsGatewayUserKeyDefault ="3e9ff18b7a05###";
  // static String smsGatewayPassKeyDefault ="lddnftmwjc####";
  // static String tokenUrlDefault = "https://workplan-uat.aplikasidev.com/reset?token=###";

  // "userkey": "3e9ff18b7a05",
  // "passkey": "lddnftmwjc",

  static String fParameterUsaha = "parameter_usaha";
  static String fParameterActivity = "parameter_activity";
  static String fParameterDokumen = "parameter_dokumen";
  static String fParameterUdfOption1 = "parameter_udf_option1";
  static String fParameterUdfOption = "parameter_udf_option";

  static DateFormat formatDateDisplay = DateFormat("dd/MM/yyyy");
  static DateFormat formatDateValue = DateFormat("yyyy-MM-dd");
  static DateFormat formatDateTimeValue = DateFormat("yyyy-MM-dd HH:mm");
  static String strFormatDateValue = "yyyy-MM-dd";
  static String strFormatDateHint = "dd/MM/yyyy";
  static String fPersonalInfo = "personal_info_by_user_id";
  static String fPersonalInfoUpdate = "personal_info_update";
  static String fChangePassword = "change_password";
  static DateFormat formatDateTimeUnique = DateFormat("yyyyMMddHHmmss");
  // static String fChangePassword = "change_password";

  static String fPersonaAddressCreate = "personal_address_create";
  static String fPersonaAddresUpdate = "personal_address_update";
  static String fPersonaAddresUpdateStatus = "personal_address_update_status";
  static String fPersonaAddressById = "personal_address_by_id";
  static String fPersonaAddressByUserId = "personal_address_by_user_id";
  static String fPersonaInfoContactUpdate = "personal_info_update_contact";

  static String defaultValueOptionDesc = "";
  static int defaultValueOptionId = 0;
  static String fParameterKategoriProduk = "parameter_kategori_produk";
  static String fParameterKategoriProdukByCompanyId =
      "parameter_kategori_produk_by_company_id";
  static String fParameterProduk = "parameter_produk";
  static String fParameterProdukByCompanyId = "parameter_produk_by_company_id";
  static String fParameterDokumenWorkplan = "parameter_dokumen_workplan";
  static String fUploadImage = "uploadImage";
  static String fParameterUdfList = "parameter_udf";
  static DateFormat formatTime = DateFormat("HH:mm");
  static String fPersonalEducationByUserId = "personal_education_by_user_id";
  static String fPersonalEducationById = "personal_education_by_id";
  static String fPersonalEducationCreate = "personal_education_create";
  static String fPersonalEducationUpdate = "personal_education_update";
  static String fPersonalEducationUpdateStatus =
      "personal_education_update_status";

  static String fPersonalWorkExperienceByUserId =
      "personal_work_experience_by_user_id";
  static String fPersonalWorkExperienceById = "personal_work_experience_by_id";
  static String fPersonalWorkExperienceCreate =
      "personal_work_experience_create";
  static String fPersonalWorkExperienceUpdate =
      "personal_work_experience_update";
  static String fPersonalWorkExperienceUpdateStatus =
      "personal_work_experience_update_status";

  static String fPersonalCertificateByUserId =
      "personal_certificate_by_user_id";
  static String fPersonalCertificateById = "personal_certificate_by_id";
  static String fPersonalCertificateCreate = "personal_certificate_create";
  static String fPersonalCertificateUpdate = "personal_certificate_update";
  static String fPersonalCertificateUpdateStatus =
      "personal_certificate_update_status";

  static String fPersonalLanguageByUserId = "personal_language_by_user_id";
  static String fPersonalLanguageById = "personal_language_by_id";
  static String fPersonalLanguageCreate = "personal_language_create";
  static String fPersonalLanguageUpdate = "personal_language_update";
  static String fPersonalLanguageUpdateStatus =
      "personal_language_update_status";

  static String fPersonalTrainingByUserId = "personal_training_by_user_id";
  static String fPersonalTrainingById = "personal_training_by_id";
  static String fPersonalTrainingCreate = "personal_training_create";
  static String fPersonalTrainingUpdate = "personal_training_update";
  static String fPersonalTrainingUpdateStatus =
      "personal_training_update_status";

  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  static String fUploadImageCheckIn = "upload_image_check_in";
  static String fParameterTujuanKunjungan = "parameter_tujuan_kunjungan";
  static String fParameterTujuanKunjunganByCompanyId =
      "parameter_tujuan_kunjungan_by_company_id";
  static String fParameterHasilKunjungan = "parameter_hasil_kunjungan";
  static String fParameterHasilKunjunganByCompanyId =
      "parameter_hasil_kunjungan_by_company_id";
  static String fWorkplanUdfUpdate = "workplan_udf_update";
  static String fWorkplanMessagesByWorkplanId =
      "workplan_messages_by_workplan_id";
  static String fWorkplanMessagesByUserId = "workplan_messages_by_user_id";
  static String fParameterDokumenWorkplanMapping =
      "parameter_dokumen_workplan_mapping";
  static String fParameterDokumenWorkplanMappingByDocumentId =
      "parameter_dokumen_workplan_mapping_by_document_id";
  static String fImageDownload = "download_workplan_dokumen";
  static String fCheckInBatasWaktu = "check_in_batas_waktu";
  static String fUploadImageProfile = "upload_image_profile";
  static String fWorkplanVisitById = "workplan_visit_by_id";
  static String fParameterMappingAktifitas = "parameter_mapping_aktifitas";
  static String fWorkplanDokumenByUserId = "workplan_dokumen_by_user_id";
  static String fMenu = "menu";
  static String menuCodeTaskInbox = "INBOX";
  static String menuCodeTask = "TASK";
  static String menuCodeTaskParent = "TASK_PARENT";

  static String fNotice = "notice";
  static String fNoticeUpdateRead = "notice_update_read";
  // static String fMessageByUserId = "messages_by_user_id";

  static int firstDate = 1900;
  static int lastDate = 2100;
  static int yearNow = new DateTime.now().year;
  static String fPersonalFamilyByUserId = "personal_family_by_user_id";
  static String fPersonalFamilyById = "personal_family_by_id";
  static String fPersonalFamilyCreate = "personal_family_create";
  static String fPersonalFamilyUpdate = "personal_family_update";
  static String fPersonalFamilyUpdateStatus = "personal_family_update_status";
  // static

  static Map<int, Color> color = {
    50: Color.fromRGBO(255, 92, 87, .1),
    100: Color.fromRGBO(255, 92, 87, .2),
    200: Color.fromRGBO(255, 92, 87, .3),
    300: Color.fromRGBO(255, 92, 87, .4),
    400: Color.fromRGBO(255, 92, 87, .5),
    500: Color.fromRGBO(255, 92, 87, .6),
    600: Color.fromRGBO(255, 92, 87, .7),
    700: Color.fromRGBO(255, 92, 87, .8),
    800: Color.fromRGBO(255, 92, 87, .9),
    900: Color.fromRGBO(255, 92, 87, 1),
  };

  static MaterialColor colorCustom = MaterialColor(0xFF4fa06d, color);

//  static var requiredValidator = RequiredValidator(errorText: 'this field is required');

  static var maskFormatterNPWP = new MaskTextInputFormatter(
      mask: '##.###.###.#-###.###', filter: {"#": RegExp(r'[0-9]')});

  static var validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');
  // final validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');
  static var charactersNUmber = RegExp(r'[^0-9]');
  static String fUpdateLanguageBiometrik = "update_language_biometrik";
  static String mediaTypeCode = "KOTAK_PERSONAL";

  static String fUploadImageCheckInOut = "upload_image_check_in_out";
  static String fUpdateIsLogin = "update_is_login";
  static String fGetEnvS3 = "get_env_s3";
  static String EnvAWS = "AWS_DOWNLOAD_URL";
}
