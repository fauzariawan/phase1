import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workplan_beta_test/model/device_location_model.dart';
import 'package:workplan_beta_test/model/env_model.dart';
import 'package:workplan_beta_test/model/menu_otorize_model.dart';
import 'package:workplan_beta_test/model/notice_model.dart';
import 'package:workplan_beta_test/model/parameter_activity_model.dart';
import 'package:workplan_beta_test/model/parameter_hasil_kunjungan.dart';
import 'package:workplan_beta_test/model/parameter_kategori_produk_model.dart';
import 'package:workplan_beta_test/model/parameter_mapping_aktifitas_model.dart';
import 'package:workplan_beta_test/model/parameter_model.dart';
import 'package:workplan_beta_test/model/parameter_produk_model.dart';
import 'package:workplan_beta_test/model/parameter_progres_status_model.dart';
import 'package:workplan_beta_test/model/parameter_tujuan_kunjungan.dart';
import 'dart:io' as io;
import 'package:workplan_beta_test/model/parameter_udf_model.dart';
import 'package:workplan_beta_test/model/parameter_udf_option_model.dart';
import 'package:workplan_beta_test/model/parameter_usaha_model.dart';
import 'package:workplan_beta_test/model/personal_info_photo_model.dart';
import 'package:workplan_beta_test/model/user_model.dart';
import 'package:workplan_beta_test/model/visit_checkin_log_model.dart';
import 'package:workplan_beta_test/model/workplan_dokumen_model.dart';
import 'package:workplan_beta_test/model/workplan_inbox_model.dart';
import 'package:workplan_beta_test/model/workplan_messages.dart';
import 'package:workplan_beta_test/model/workplan_visit_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static late Database _db;

  String tableParameterActivity = "CREATE TABLE parameter_activity(" +
      "id INTEGER PRIMARY KEY, " +
      "company_id INTEGER , " +
      "code TEXT , " +
      "description TEXT , " +
      "status INTEGER , " +
      "batas_waktu INTEGER , " +
      "maksimal_umur INTEGER , " +
      "flag INTEGER  " +
      ")";

  String tableParameterProgresStatus =
      "CREATE TABLE parameter_progres_status(" +
          "id INTEGER PRIMARY KEY, " +
          "company_id INTEGER , " +
          "code TEXT , " +
          "description TEXT , " +
          "status INTEGER  " +
          ")";

  String tableParameterUdfOption = "CREATE TABLE parameter_udf_option(" +
      "id INTEGER PRIMARY KEY, " +
      "company_id INTEGER , " +
      "option_code TEXT , " +
      "option_description TEXT , " +
      "status TEXT,  " +
      "udf_id INTEGER)";

  String tableWorkplanActivity = "CREATE TABLE workplan_activity(" +
      "workplan_activity_pk INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "id INTEGER, " +
      "distribusi_workplan_id INTEGER ," +
      "activity_id INTEGER ," +
      "full_name TEXT ," +
      "phone TEXT ," +
      "location TEXT ," +
      "alamat TEXT ," +
      "rencana_kunjungan TEXT ," +
      "user_id INTEGER ," +
      "progres_status_id INTEGER ," +
      "nomor_workplan TEXT ," +
      "kecamatan TEXT ," +
      "kabupaten TEXT ," +
      "kodepos TEXT ," +
      "aktual_kunjungan TEXT ," +
      "kunjungan_ke INTEGER ," +
      "catatan_kunjungan TEXT ," +
      "tujuan_kunjungan_id INTEGER ," +
      "hasil_kunjungan_id INTEGER ," +
      "udf_text1 TEXT ," +
      "udf_text2 TEXT ," +
      "udf_num1 INTEGER ," +
      "udf_opt1 INTEGER ," +
      "udf_date1 TEXT ," +
      "kelurahan TEXT ," +
      "lama_usaha INTEGER ," +
      "jenis_usaha_id INTEGER ," +
      "npwp TEXT ," +
      "identity_card_no TEXT ," +
      "gender_id INTEGER ," +
      "gender_desc TEXT ," +
      "marital_status_id INTEGER ," +
      "marital_status_desc TEXT ," +
      "date_of_birth TEXT ," +
      "place_of_birth TEXT ," +
      "kategori_produk_id INTEGER ," +
      "jenis_produk_id TEXT ," +
      "nominal_transaksi INTEGER ," +
      "keputusan TEXT ," +
      "alasan_tolak_id INTEGER ," +
      "prof_of_call INTEGER ," +
      "company_id INTEGER ," +
      "udf_text_b1 TEXT ," +
      "udf_text_b2 TEXT ," +
      "udf_num_b1 INTEGER ," +
      "udf_num_b2 INTEGER ," +
      "udf_date_b1 TEXT ," +
      "udf_date_b2 TEXT ," +
      "udf_ddl_b1 INTEGER ," +
      "udf_ddl_b2 INTEGER ," +
      "personal_phone TEXT ," +
      "personal_alamat TEXT ," +
      "personal_kecamatan TEXT ," +
      "personal_kabupaten TEXT ," +
      "personal_kodepos TEXT ," +
      "personal_kelurahan TEXT ," +
      "activity_code TEXT ," +
      "activity_description TEXT ," +
      "progres_status_code TEXT ," +
      "progres_status_description TEXT ," +
      "jenis_usaha_code TEXT ," +
      "jenis_usaha_description TEXT ," +
      "udf_text_c1 TEXT ," +
      "udf_num_c1 INTEGER ," +
      "udf_date_c1 TEXT ," +
      "udf_text_d1 TEXT ," +
      "udf_text_d2 TEXT ," +
      "udf_text_d3 TEXT ," +
      "udf_num_d1 INTEGER ," +
      "udf_num_d2 INTEGER ," +
      "udf_num_d3 INTEGER ," +
      "udf_date_d1 TEXT ," +
      "udf_date_d2 TEXT ," +
      "udf_date_d3 TEXT ," +
      "udf_ddl_d1 INTEGER ," +
      "udf_ddl_d2 INTEGER ," +
      "udf_ddl_d3 INTEGER ," +
      "alasan_tolak_description TEXT ," +
      "is_check_in TEXT ," +
      "flag INTEGER ," +
      "maximum_date TEXT ," +
      "progres_status_id_alter INTEGER ," +
      "progres_status_id_alter_description TEXT,  " +
      "nomor_workplan_inbox TEXT, " +
      "flag_update INTEGER, " +
      "flag_update_personal INTEGER, " +
      "flag_update_produk INTEGER, " +
      "flag_update_udf INTEGER, " +
      "receive_date TEXT,"+
      "progres_status_id_real INTEGER, " +
      "maksimal_umur_date TEXT " +
          ")";

  String tableWorkplanVisit = "CREATE TABLE workplan_visit(" +
      "workplan_visit_pk INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "id INTEGER , " +
      "workplan_no TEXT," +
      "user_company_id INTEGER," +
      "company_id INTEGER," +
      "activities_id INTEGER," +
      "client_id INTEGER," +
      "first_visit TEXT," +
      "check_in TEXT," +
      "check_out TEXT," +
      "note TEXT," +
      "status INTEGER," +
      "created_at TEXT," +
      "updated_at TEXT," +
      "check_in_latitude TEXT," +
      "check_in_longitude TEXT," +
      "check_out_latitude TEXT," +
      "check_out_longitude TEXT," +
      "address_check_in TEXT," +
      "address_check_out TEXT," +
      "timezone TEXT," +
      "photo_check_in TEXT," +
      "photo_check_out TEXT," +
      "visit_purpose_id INTEGER," +
      "visit_result_id INTEGER," +
      "workplan_activity_id INTEGER," +
      "visit_date_plan TEXT," +
      "visit_date_actual TEXT," +
      "visit_purpose_code TEXT," +
      "visit_purpose_description TEXT," +
      "visit_result_code TEXT," +
      "visit_result_description TEXT," +
      "is_check_in TEXT," +
      "is_check_out TEXT," +
      "batas_waktu INTEGER," +
      "check_in_batas TEXT," +
      "base_image_check_in TEXT," +
      "base_image_check_out TEXT," +
      "flag_update INTEGER," +
      "updated_by INTEGER" +
      ")";

  String tableParameter = "CREATE TABLE parameter(" +
      "id INTEGER PRIMARY KEY, " +
      "parameter_type TEXT," +
      "parameter_name TEXT," +
      "parameter_value TEXT," +
      "parameter_note TEXT," +
      "parameter_code TEXT," +
      "status INTEGER," +
      "company_id INTEGER" +
      ")";

// map["code"] = code;
//     map["description"] = description;
  String tableParameterUsaha = "CREATE TABLE parameter_usaha(" +
      "id INTEGER PRIMARY KEY, " +
      "company_id INTEGER," +
      "status INTEGER," +
      "code TEXT," +
      "description TEXT" +
      ")";

  String tableParameterKategoriProduk =
      "CREATE TABLE parameter_kategori_produk(" +
          "id INTEGER PRIMARY KEY, " +
          "company_id INTEGER," +
          "status INTEGER," +
          "code TEXT," +
          "description TEXT," +
          "code_aktifitas TEXT," +
          "activity_id INTEGER" +
          ")";

  String tableParameterProduk = "CREATE TABLE parameter_produk(" +
      "id INTEGER PRIMARY KEY, " +
      "company_id INTEGER," +
      "status INTEGER," +
      "code TEXT," +
      "description TEXT," +
      "code_aktifitas TEXT," +
      "code_kategori_produk TEXT," +
      "kategori_produk_id INTEGER" +
      ")";

  String tableParameterHasilKunjungan =
      "CREATE TABLE parameter_hasil_kunjungan(" +
          "id INTEGER PRIMARY KEY, " +
          "company_id INTEGER," +
          "status INTEGER," +
          "code TEXT," +
          "description TEXT," +
          "id_aktifitas INTEGER," +
          "id_kategori_produk INTEGER," +
          "id_produk INTEGER" +
          ")";

  String tableParameterTujuanKunjungan =
      "CREATE TABLE parameter_tujuan_kunjungan(" +
          "id INTEGER PRIMARY KEY, " +
          "company_id INTEGER," +
          "status INTEGER," +
          "code TEXT," +
          "description TEXT," +
          "id_aktifitas INTEGER," +
          "id_kategori_produk INTEGER," +
          "id_produk INTEGER" +
          ")";

  String tableWorkplanMessages = "CREATE TABLE workplan_messages(" +
      "id INTEGER PRIMARY KEY, " +
      "company_id INTEGER," +
      "created_at TEXT," +
      "user_id INTEGER," +
      "body TEXT," +
      "workplan_activity_id INTEGER" +
      ")";

  String tablePersonalInfoPhoto = "CREATE TABLE personal_info_photo(" +
      "id INTEGER PRIMARY KEY, " +
      "user_id INTEGER," +
      "image_path TEXT"
          ")";

  String tableDeviceLocation = "CREATE TABLE device_location(" +
      "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "created_date TEXT," +
      "address TEXT," +
      "longitude TEXT," +
      "latitude TEXT )";

  String tableMenuOtorize = "CREATE TABLE menu_otorize(" +
      "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "menu_id INTEGER," +
      "menu_name TEXT," +
      "menu_desc TEXT," +
      "can_read INTEGER," +
      "can_write INTEGER," +
      "can_update INTEGER," +
      "can_approve INTEGER,"+
       "menu_code TEXT)";

  // int mappingId;
  // int mappingStatus;
  // int productId;
  // int documentId;
  // int mandatory;
  // int maxphoto;
  // int companyId;
  // int approvedStatus;
  // String dokumenDescription;
  //"mapping_status INTEGER," +
  String tableParameterMappingActivity =
      "CREATE TABLE parameter_mapping_activity(" +
          "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
          "mapping_id INTEGER," +
          "product_id INTEGER," +
          "document_id INTEGER," +
          "mandatory_int INTEGER," +
          "mapping_status_int INTEGER," +
          "maxphoto INTEGER," +
          "company_id INTEGER," +
          "approved_status INTEGER," +
          "dokumen_description TEXT )";

  String tableWorkplanDokumen = "CREATE TABLE workplan_dokumen(" +
      "id_pk INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "id INTEGER," +
      "workplan_activity_id INTEGER," +
      "dokumen_id INTEGER," +
      "dokumen TEXT," +
      "company_id INTEGER," +
      "dokumen_base_img TEXT," +
      "flag_update INTEGER" +
      ")";

  String dropTableUser = " DROP TABLE User ";
  String tableUser = "CREATE TABLE User (id_pk INTEGER PRIMARY KEY AUTOINCREMENT,id INTEGER ,email TEXT,encrypted_password TEXT, username TEXT, full_name TEXT, phone TEXT, language_type INTEGER,company_code TEXT,is_biometrik TEXT,organization_id INTEGER,function_id INTEGER,structure_id INTEGER,employee_status INTEGER,user_company_id INTEGER,package_type INTEGER,role_id INTEGER,is_login_mobile TEXT,timeout_login INTEGER,last_sign_in_at TEXT,resign_date TEXT, resign_flag INTEGER,device_id TEXT)";

  String tableEnv = "CREATE TABLE env(id_pk INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, value TEXT)";

  Future<Database> get db async {
    //if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "db_workplan_30122021.db");
    var theDb = await openDatabase(path, version: 3, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    //User
    //await db.execute(dropTableUser);
    await db.execute(tableUser);

    //ParameterUdf
    await db.execute(
        "CREATE TABLE ParameterUdf(id INTEGER PRIMARY KEY,udf_name TEXT,udf_type TEXT,udf_description TEXT,company_id INTEGER)");
    //VisitCheckInLog
    await db.execute(
        "CREATE TABLE VisitCheckInLog (visit_id INTEGER PRIMARY KEY, check_in TEXT, check_in_batas TEXT, batas_waktu INTEGER,nomor_workplan TEXT)");
    //Notice
    await db.execute(
        "CREATE TABLE Notice(id_pk INTEGER PRIMARY KEY AUTOINCREMENT,id INTEGER ,company_id INTEGER ,notice_type INTEGER,notice_title TEXT,notice_body TEXT,status INTEGER,receive_id INTEGER,media_type INTEGER,created_name TEXT,notice_type_code TEXT,media_type_code TEXT,created_at TEXT,is_read TEXT,created_username TEXT)");

    //Workplan Activity
    await db.execute(tableWorkplanActivity);

    //tableParameterUdf
    await db.execute(tableParameterUdfOption);

    //tableParameterActivity
    await db.execute(tableParameterActivity);

    //tableWorkplanVisit
    await db.execute(tableWorkplanVisit);

    //tableParameterProgresStatus
    await db.execute(tableParameterProgresStatus);

    //tableParameter
    await db.execute(tableParameter);

    //tableParameterUsaha
    await db.execute(tableParameterUsaha);

    //tableParameterKategoriProduk
    await db.execute(tableParameterKategoriProduk);

    //tableParameterProduk
    await db.execute(tableParameterProduk);

    //tableParameterHasilKunjungan
    await db.execute(tableParameterHasilKunjungan);

    //tableParameterTujuanKunjungan
    await db.execute(tableParameterTujuanKunjungan);

    //tableWorkplanMessages
    await db.execute(tableWorkplanMessages);

    //tablePersonalInfo
    await db.execute(tablePersonalInfoPhoto);

    //tableDeviceLocation
    await db.execute(tableDeviceLocation);

    //tableParameterMappingActivity
    await db.execute(tableParameterMappingActivity);

    //tableWorkplanDokumen
    await db.execute(tableWorkplanDokumen);

    await db.execute(tableMenuOtorize);

    await db.execute(tableEnv);
  }

  Future<int> insertMenuOtorize(MenuOtorize object) async {
    var dbClient = await db;
    int count = await dbClient.insert('menu_otorize', object.toMap());
    return count;
  }

  Future<int> insertEnv(Env object) async {
    var dbClient = await db;
    int count = await dbClient.insert('env', object.toMap());
    return count;
  }

  Future<Env> getEnvByName(String name) async {

   var dbClient = await db;
    var mapList = await dbClient.query('env', where: 'name=? ', whereArgs: [name]);
    return new Env.fromJson(mapList.first);

  }


  Future<MenuOtorize> getMenuOtorizeByMenuCode(String menuCode) async {

   var dbClient = await db;
    var mapList = await dbClient.query('menu_otorize', where: 'menu_code=? ', whereArgs: [menuCode]);
    return new MenuOtorize.fromJson(mapList.first);

  }

  deleteMenuOtorize() async {
    var dbClient = await db;
    int count = await dbClient.delete('menu_otorize');
    return count;
  }


  Future<int> insertWorkplanDokumen(WorkplanDokumen object) async {
    var dbClient = await db;
    int count = await dbClient.insert('workplan_dokumen', object.toMap());
    return count;
  }

  Future<List<WorkplanDokumen>> getListWorkplanDokumenByDokumenId(
      String dokumenId) async {
    var parameterList = await selectListWorkplanDokumenByDokumenId(dokumenId);
    int count = parameterList.length;
    List<WorkplanDokumen> dtList = <WorkplanDokumen>[];
    for (int i = 0; i < count; i++) {
      dtList.add(WorkplanDokumen.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectListWorkplanDokumenByDokumenId(
      String dokumenId) async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient.query('workplan_dokumen',
        where: 'dokumen_id=? ', whereArgs: [int.parse(dokumenId)]);
    return mapList;
  }

  Future<int> insertParameterMappingActivity(
      ParameterMappingAktifitas object) async {
    var dbClient = await db;
    int count =
        await dbClient.insert('parameter_mapping_activity', object.toMap());
    return count;
  }

  Future<DeviceLocation> getDeviceLocation() async {
    var dbClient = await db;
    var mapList = await dbClient.query('device_location');
    return new DeviceLocation.fromJson(mapList.first);
  }

  deleteDeviceLocation() async {
    var dbClient = await db;
    int count = await dbClient.delete('device_location');
    return count;
  }

  Future<int> insertDeviceLocation(DeviceLocation object) async {
    var dbClient = await db;
    int count = await dbClient.insert('device_location', object.toMap());
    return count;
  }

  Future<int> insertPersonalInfoPhoto(Map<String, dynamic> map) async {
    var dbClient = await db;
    int count = await dbClient.insert('personal_info_photo', map);
    return count;
  }

  Future<PersonalInfoPhoto?> getPersonalInfoPhoto(String userid) async {
    var dbClient = await db;
    var mapList = await dbClient.query('personal_info_photo',
        where: 'user_id=? ', whereArgs: [int.parse(userid)]);
    if (mapList.isNotEmpty) {
      return new PersonalInfoPhoto.fromJson(mapList.first);
    } else {
      return null;
    }
  }

  Future<int> deletePersonalInfoPhoto() async {
    var dbClient = await db;
    int count = await dbClient.delete('personal_info_photo');
    return count;
  }

  Future<int> insertWorkplanMessages(WorkplanMessages object) async {
    var dbClient = await db;
    int count = await dbClient.insert('workplan_messages', object.toMap());
    return count;
  }

  Future<List<ParameterMappingAktifitas>>
      getListParameterMappingActivityByProdukId(String produkId) async {
    var parameterList =
        await selectListParameterMappingActivityByProdukId(produkId);
    int count = parameterList.length;
    List<ParameterMappingAktifitas> dtList = <ParameterMappingAktifitas>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterMappingAktifitas.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>>
      selectListParameterMappingActivityByProdukId(String produkId) async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient.query('parameter_mapping_activity',
        where: 'product_id=? ', whereArgs: [int.parse(produkId)]);
    return mapList;
  }

  Future<List<WorkplanMessages>> getWorkplanMessagesByWorkplanActivityId(
      String workplanActivityId) async {
    var parameterList = await selectListWorkplanMessagesByWorkplanActivityId(
        workplanActivityId);
    int count = parameterList.length;
    List<WorkplanMessages> dtList = <WorkplanMessages>[];
    for (int i = 0; i < count; i++) {
      dtList.add(WorkplanMessages.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>>
      selectListWorkplanMessagesByWorkplanActivityId(
          String workplanActivityId) async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient.query('workplan_messages',
        where: 'workplan_activity_id=? ',
        whereArgs: [int.parse(workplanActivityId)]);
    return mapList;
  }

  Future<int> insertParameterHasilKunjungan(
      ParameterHasilKunjungan object) async {
    var dbClient = await db;
    int count =
        await dbClient.insert('parameter_hasil_kunjungan', object.toMap());
    return count;
  }

  Future<int> insertParameterTujuanKunjungan(
      ParameterTujuanKunjungan object) async {
    var dbClient = await db;
    int count =
        await dbClient.insert('parameter_tujuan_kunjungan', object.toMap());
    return count;
  }

  Future<int> insertParameterProduk(ParameterProduk object) async {
    var dbClient = await db;
    int count = await dbClient.insert('parameter_produk', object.toMap());
    return count;
  }

  Future<int> insertParameterKategoriProduk(
      ParameterKategoriProduk object) async {
    var dbClient = await db;
    int count =
        await dbClient.insert('parameter_kategori_produk', object.toMap());
    return count;
  }

  Future<List<ParameterHasilKunjungan>> getParametHasilKunjunganByProdukId(
      String idProduk) async {
    var parameterList =
        await selectListParameteHasilKunjunganByProdukId(idProduk);
    int count = parameterList.length;
    List<ParameterHasilKunjungan> dtList = <ParameterHasilKunjungan>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterHasilKunjungan.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectListParameteHasilKunjunganByProdukId(
      String idProduk) async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient.query('parameter_hasil_kunjungan',
        where: 'id_produk=? ', whereArgs: [int.parse(idProduk)]);
    return mapList;
  }

  Future<List<ParameterTujuanKunjungan>> getParameteTujuanKunjunganByProdukId(
      String idProduk) async {
    var parameterList =
        await selectListParameteTujuanKunjunganByProdukId(idProduk);
    int count = parameterList.length;
    List<ParameterTujuanKunjungan> dtList = <ParameterTujuanKunjungan>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterTujuanKunjungan.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>>
      selectListParameteTujuanKunjunganByProdukId(String idProduk) async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient.query('parameter_tujuan_kunjungan',
        where: 'id_produk=? ', whereArgs: [int.parse(idProduk)]);
    return mapList;
  }

  Future<List<Map<String, dynamic>>>
      selectListParameterKategoriProdukByActivityId(String activityId) async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient.query('parameter_kategori_produk',
        where: 'activity_id=? ', whereArgs: [int.parse(activityId)]);
    return mapList;
  }

  Future<List<ParameterKategoriProduk>> getParameterKategoriProdukByActivityId(
      String activityId) async {
    var parameterList =
        await selectListParameterKategoriProdukByActivityId(activityId);
    int count = parameterList.length;
    List<ParameterKategoriProduk> dtList = <ParameterKategoriProduk>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterKategoriProduk.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectListParameterProdukByKategoriId(
      String kategoriProdukId) async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient.query('parameter_produk',
        where: 'kategori_produk_id=? ',
        whereArgs: [int.parse(kategoriProdukId)]);
    return mapList;
  }

  Future<List<ParameterProduk>> getParameterProdukByKategoriId(
      String kategoriProdukId) async {
    var parameterList =
        await selectListParameterProdukByKategoriId(kategoriProdukId);
    int count = parameterList.length;
    List<ParameterProduk> dtList = <ParameterProduk>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterProduk.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<int> insertParameterUsaha(ParameterUsaha object) async {
    var dbClient = await db;
    int count = await dbClient.insert('parameter_usaha', object.toMap());
    return count;
  }

  Future<List<Map<String, dynamic>>> selectListParameterUsaha() async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient.query('parameter_usaha');
    return mapList;
  }

  Future<List<ParameterUsaha>> getParameterUsahaList() async {
    var parameterList = await selectListParameterUsaha();
    int count = parameterList.length;
    List<ParameterUsaha> dtList = <ParameterUsaha>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterUsaha.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<Parameter> getParameterByCode(String parameterCode) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM parameter WHERE parameter_code=" + parameterCode + " limit 1");
    return new Parameter.fromJson(res.first);
  }

  Future<int> insertParameter(Parameter object) async {
    var dbClient = await db;
    int count = await dbClient.insert('parameter', object.toMap());
    return count;
  }

  Future<List<Map<String, dynamic>>> selectListParameterByType(
      String type) async {
    var dbClient = await db;
    // var mapList = await dbClient.query('parameter');
    var mapList = await dbClient
        .query('parameter', where: 'parameter_type=? ', whereArgs: [type]);
    return mapList;
  }

  Future<List<Parameter>> getParameterListByType(String type) async {
    var parameterList = await selectListParameterByType(type);
    int count = parameterList.length;
    List<Parameter> dtList = <Parameter>[];
    for (int i = 0; i < count; i++) {
      dtList.add(Parameter.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<ParameterProgresStatus> getParameterProgresStatusById(String pId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM parameter_progres_status WHERE id=" + pId + " limit 1");
    return new ParameterProgresStatus.fromJson(res.first);
  }

  Future<ParameterProgresStatus> getParameterProgresStatusByCode(String code) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM parameter_progres_status WHERE code=" + code + " limit 1");
    return new ParameterProgresStatus.fromJson(res.first);
  }

  Future<int> insertParameterProgresStatus(
      ParameterProgresStatus object) async {
    var dbClient = await db;
    int count =
        await dbClient.insert('parameter_progres_status', object.toMap());
    return count;
  }

  Future<List<Map<String, dynamic>>> selectListParameterProgresStatus() async {
    var dbClient = await db;
    var mapList = await dbClient.query('parameter_progres_status');
    return mapList;
  }

  Future<List<ParameterProgresStatus>> getParameterProgresStatusList() async {
    var parameterList = await selectListParameterProgresStatus();
    int count = parameterList.length;
    List<ParameterProgresStatus> dtList = <ParameterProgresStatus>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterProgresStatus.fromJson(parameterList[i]));
    }
    return dtList;
  }

  Future<int> insertParameterActivity(ParameterActivity object) async {
    var dbClient = await db;
    int count = await dbClient.insert('parameter_activity', object.toMap());
    return count;
  }

  Future<List<Map<String, dynamic>>> selectListParameterActivity() async {
    var dbClient = await db;
    var mapList = await dbClient.query('parameter_activity');
    return mapList;
  }

  Future<List<ParameterActivity>> getParameterActivityList() async {
    var parameterActivityList = await selectListParameterActivity();
    int count = parameterActivityList.length;
    List<ParameterActivity> dtList = <ParameterActivity>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterActivity.fromJson(parameterActivityList[i]));
    }
    return dtList;
  }

  Future<int> insertUser(User object) async {
    var dbClient = await db;
    int count = await dbClient.insert('User', object.toMap());
    return count;
  }

  Future<int> updateUser(User object) async {
    var dbClient = await db;
    int count = await dbClient.update('User', object.toMap(),
        where: 'username=? or email=?',
        whereArgs: [object.username, object.username]);
    return count;
  }

  // Future<User> getUser(String userid) async {

  //   var dbClient = await db;
  //   var res = await dbClient.rawQuery("SELECT * FROM User limit 1");
  //   return new User.fromJson(res.first);

  // }

  // Future<User> getUserByUserId(String userid) async {

  //   var dbClient = await db;
  //   var res = await dbClient.rawQuery("SELECT * FROM User WHERE username='" + userid + "' or email = '" + userid + "' limit 1");
  //   return new User.fromJson(res.first);

  // }

  Future<User> getUserById(String userCompanyId) async {
    var dbClient = await db;
    var res =
        await dbClient.query('User', where: 'user_company_id=?', whereArgs: [int.parse(userCompanyId)]);
      return new User.fromJson(res.first);
  }

  Future<List<Map<String, dynamic>>> selectListUserByUsername(
      String username) async {
    var dbClient = await db;
    var mapList = await dbClient.query('User',
        where: 'lower(username)=? or lower(email)=?',
        whereArgs: [username.toLowerCase(), username.toLowerCase()]);
    return mapList;
  }

  Future<List<User>> getUserListByUsername(String username) async {
    var userList = await selectListUserByUsername(username);
    int count = userList.length;
    List<User> dtList = <User>[];
    for (int i = 0; i < count; i++) {
      dtList.add(User.fromJson(userList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectListNotice(String companyId) async {
    var dbClient = await db;
    var mapList = await dbClient.query('Notice',where: 'company_id=?', whereArgs: [int.parse(companyId)]);
    return mapList;
  }

  Future<List<Notice>> getNoticeList(String companyId) async {
    var noticeList = await selectListNotice(companyId);
    int count = noticeList.length;
    List<Notice> dtList = <Notice>[];
    for (int i = 0; i < count; i++) {
      dtList.add(Notice.fromJson(noticeList[i]));
    }
    return dtList;
  }

  Future<int> insertNotice(Notice object) async {
    var dbClient = await db;
    int count = await dbClient.insert('Notice', object.toMap());
    return count;
  }

  Future<int> insertParameterUdf(ParameterUdf object) async {
    var dbClient = await db;
    int count = await dbClient.insert('ParameterUdf', object.toMap());
    return count;
  }

  Future<int> insertVisitCheckInLog(VisitChecInLog object) async {
    var dbClient = await db;
    int count = await dbClient.insert('VisitCheckInLog', object.toMap());
    return count;
  }

  Future<List<Map<String, dynamic>>> selectListVisitCheckInLog() async {
    var dbClient = await db;
    var mapList = await dbClient.query('VisitCheckInLog');
    return mapList;
  }

  Future<VisitChecInLog> getListVisitCheckInLog(String visitId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM VisitCheckInLog WHERE visit_id='" +
            visitId +
            "' limit 1");
    return new VisitChecInLog.fromJson(res.first);
  }

  Future<List<Map<String, dynamic>>> selectListVisitCheckInLogByNoWorkplan(
      nomorWorkplan) async {
    var dbClient = await db;
    var mapList = await dbClient.query('VisitCheckInLog',
        where: 'nomor_workplan=?', whereArgs: [nomorWorkplan]);
    return mapList;
  }

  Future<List<VisitChecInLog>> getVisitCheckInLogList() async {
    var visitCheckinList = await selectListVisitCheckInLog();
    int count = visitCheckinList.length;
    List<VisitChecInLog> dtList = <VisitChecInLog>[];
    for (int i = 0; i < count; i++) {
      dtList.add(VisitChecInLog.fromJson(visitCheckinList[i]));
    }
    return dtList;
  }

  Future<List<VisitChecInLog>> getVisitCheckInLogListByNoWorkplan(
      String nomorWorkplan) async {
    var visitCheckinList =
        await selectListVisitCheckInLogByNoWorkplan(nomorWorkplan);
    int count = visitCheckinList.length;
    List<VisitChecInLog> dtList = <VisitChecInLog>[];
    for (int i = 0; i < count; i++) {
      dtList.add(VisitChecInLog.fromJson(visitCheckinList[i]));
    }
    return dtList;
  }

  Future<ParameterUdf> getParameterUdfByName(String udfName) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM ParameterUdf WHERE udf_name='" + udfName + "' limit 1");
    return new ParameterUdf.fromJson(res.first);
  }

  Future<int> deleteVisitCheckInLog() async {
    var dbClient = await db;
    int count = await dbClient.delete('VisitCheckInLog');
    return count;
  }

  Future<int> deleteVisitCheckInLogByVisitId(visitId) async {
    Database db = await DatabaseHelper().db;
    int count = await db
        .delete('VisitCheckInLog', where: 'visit_id=?', whereArgs: [visitId]);
    return count;
  }

  //

  Future<int> deleteParameterUdf() async {
    var dbClient = await db;
    int count = await dbClient.delete('ParameterUdf');
    return count;
  }

  Future<int> deleteParameterUdfOption() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_udf_option');
    return count;
  }

  Future<List<ParameterUdfOption>> getParameterUdfOption1ByUdfId(
      int udfId) async {
    var udfOptionList = await selectParameterUdfOption1ById(udfId);
    int count = udfOptionList.length;
    List<ParameterUdfOption> dtList = <ParameterUdfOption>[];
    for (int i = 0; i < count; i++) {
      dtList.add(ParameterUdfOption.fromJson(udfOptionList[i]));
    }
    return dtList;
  }

  selectParameterUdfOption1ById(int udfId) async {
    var dbClient = await db;
    var mapList = await dbClient.query('parameter_udf_option',
        where: 'udf_id=? and status=?', whereArgs: [udfId, "1"]);
    return mapList;
  }

  Future<int> insertParameterUdfOption(ParameterUdfOption object) async {
    var dbClient = await db;
    int count = await dbClient.insert('parameter_udf_option', object.toMap());
    return count;
  }

  Future<int> deleteUser() async {
    var dbClient = await db;
    int count = await dbClient.delete('User');
    return count;
  }

  Future<int> deleteNotice() async {
    var dbClient = await db;
    int count = await dbClient.delete('Notice');
    return count;
  }

  Future<List<User>> getUserList() async {
    var userList = await selectListUser();
    int count = userList.length;
    List<User> dtList = <User>[];
    for (int i = 0; i < count; i++) {
      dtList.add(User.fromJson(userList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectListUser() async {
    var dbClient = await db;
    var mapList =
        await dbClient.query('User', where: 'employee_status=?', whereArgs: [1]);
    return mapList;
  }

  Future<List<Notice>> getNoticeListByMediaTypeCode(
      String mediaTypeCode) async {
    var noticeList = await selectListNoticeByMediaTypeCode(mediaTypeCode);
    int count = noticeList.length;
    List<Notice> dtList = <Notice>[];
    for (int i = 0; i < count; i++) {
      dtList.add(Notice.fromJson(noticeList[i]));
    }
    return dtList;
  }

  selectListNoticeByMediaTypeCode(String mediaTypeCode) async {
    var dbClient = await db;
    var mapList = await dbClient.query('Notice',
        where: 'media_type_code=?', whereArgs: [mediaTypeCode]);
    return mapList;
  }

  void updateNoticeListRead(List<Notice> noticeList) {
    int count = noticeList.length;
    for (int i = 0; i < count; i++) {
      noticeList[i].isRead = "1";
      updateNotice(noticeList[i]);
    }
  }

  Future<int> updateNotice(Notice object) async {
    var dbClient = await db;
    int count = await dbClient.update('Notice', object.toMap(),
        where: 'id=? ', whereArgs: [object.id]);
    return count;
  }

  Future<int> countNoticeByMediaTypeCode(String mediaTypeCode) async {
    var dbClient = await db;
    // String isRead = "0";
    var mapList = await dbClient.query('Notice',
        where: "media_type_code=? and is_read='0'", whereArgs: [mediaTypeCode]);
    // return mapList;
    //print("mapList.length:" + mapList.length.toString());
    return mapList.length;
  }

  Future<int> updateWorkplanActivity(WorkplanInboxData object) async {
    var dbClient = await db;
    int count = await dbClient.update('workplan_activity', object.toMap(),
        where: 'id=? ', whereArgs: [object.id]);
    return count;
  }

  Future<int> insertWorkplanActivity(var map) async {
    //object.toMap()
    var dbClient = await db;
    int count = await dbClient.insert('workplan_activity', map);
    return count;
  }

  Future<List<WorkplanInboxData>> getWorkplanActivityInbox() async {
    var wibList = await selectListWorkplanActivityInbox();
    int count = wibList.length;
    List<WorkplanInboxData> dtList = <WorkplanInboxData>[];
    for (int i = 0; i < count; i++) {
      // print(wibList[i].toString());
      dtList.add(WorkplanInboxData.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectListWorkplanActivityInbox() async {
    var dbClient = await db;
    var mapList = await dbClient.query("workplan_activity",
        where: "progres_status_id is null or progres_status_id = '' ");
    return mapList;
  }

  Future<int> deleteWorkplanActivityById(int id) async {
    var dbClient = await db;
    int count = await dbClient
        .delete('workplan_activity', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<int> deleteWorkplanActivityInbox() async {
    var dbClient = await db;
    int count = await dbClient.delete("workplan_activity",
        where: "progres_status_id is null or progres_status_id = '' ");
    return count;
  }

  Future<int> deleteWorkplanActivityAll() async {
    var dbClient = await db;
    int count = await dbClient.delete("workplan_activity");
    return count;
  }

  Future<List<WorkplanInboxData>> getWorkplanActivityUpdateInbox() async {
    var wibList = await selectListWorkplanActivityUpdateInbox();
    int count = wibList.length;
    List<WorkplanInboxData> dtList = <WorkplanInboxData>[];
    for (int i = 0; i < count; i++) {
      // print(wibList[i].toString());
      dtList.add(WorkplanInboxData.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>>
      selectListWorkplanActivityUpdateInbox() async {
    var dbClient = await db;
    var mapList = await dbClient
        .query("workplan_activity", where: 'flag_update=? ', whereArgs: [1]);
    return mapList;
  }

  Future<List<WorkplanInboxData>> getWorkplanActivityUpdatePersonal() async {
    var wibList = await selectListWorkplanActivityUpdatePersonal();
    int count = wibList.length;
    List<WorkplanInboxData> dtList = <WorkplanInboxData>[];
    for (int i = 0; i < count; i++) {
      // print(wibList[i].toString());
      dtList.add(WorkplanInboxData.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>>
      selectListWorkplanActivityUpdatePersonal() async {
    var dbClient = await db;
    var mapList = await dbClient.query("workplan_activity",
        where: 'flag_update_personal=? ', whereArgs: [1]);
    return mapList;
  }

  Future<List<WorkplanInboxData>> getWorkplanActivityUpdateProduk() async {
    var wibList = await selectListWorkplanActivityUpdateProduk();
    int count = wibList.length;
    List<WorkplanInboxData> dtList = <WorkplanInboxData>[];
    for (int i = 0; i < count; i++) {
      // print(wibList[i].toString());
      dtList.add(WorkplanInboxData.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>>
      selectListWorkplanActivityUpdateProduk() async {
    var dbClient = await db;
    var mapList = await dbClient.query("workplan_activity",
        where: 'flag_update_produk=? ', whereArgs: [1]);
    return mapList;
  }

  Future<List<WorkplanInboxData>> getWorkplanActivityUpdateUdf() async {
    var wibList = await selectListWorkplanActivityUpdateUdf();
    int count = wibList.length;
    List<WorkplanInboxData> dtList = <WorkplanInboxData>[];
    for (int i = 0; i < count; i++) {
      // print(wibList[i].toString());
      dtList.add(WorkplanInboxData.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>>
      selectListWorkplanActivityUpdateUdf() async {
    var dbClient = await db;
    var mapList = await dbClient.query("workplan_activity",
        where: 'flag_update_udf=? ', whereArgs: [1]);
    return mapList;
  }

  Future<List<WorkplanInboxData>> getWorkplanActivityNewTask() async {
    var wibList = await selectListWorkplanActivityNewTask();
    int count = wibList.length;
    List<WorkplanInboxData> dtList = <WorkplanInboxData>[];
    for (int i = 0; i < count; i++) {
      // print(wibList[i].toString());
      dtList.add(WorkplanInboxData.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectListWorkplanActivityNewTask() async {
    var dbClient = await db;
    var mapList =
        await dbClient.query("workplan_activity", where: "id is null");
    return mapList;
  }

  Future<List<WorkplanInboxData>> getWorkplanActivityList() async {
    var wibList = await selectListWorkplanActivityList();
    int count = wibList.length;
    List<WorkplanInboxData> dtList = <WorkplanInboxData>[];
    for (int i = 0; i < count; i++) {
      //print(wibList[i].toString());
      dtList.add(WorkplanInboxData.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<WorkplanInboxData> getWorkplanById(String id) async {
    var dbClient = await db;
    //var res = await dbClient.rawQuery("SELECT * FROM workplan_activity WHERE id='" + int.parse(id) + "' limit 1");
    var res = await dbClient.query(
      "workplan_activity",
      where: "id=?",
      whereArgs: [int.parse(id)],
    );
    return new WorkplanInboxData.fromJson(res.first);
  }

  Future<List<Map<String, dynamic>>> selectListWorkplanActivityList() async {
    var dbClient = await db;
    var mapList = await dbClient.query("workplan_activity",
        where: "progres_status_id is not null or progres_status_id != '' ",
        orderBy: "datetime(receive_date) DESC");
    return mapList;
  }

  Future<int> deleteParameterActivity() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_activity');
    return count;
  }

  Future<int> deleteWorkplanVisit() async {
    var dbClient = await db;
    int count = await dbClient.delete('workplan_visit');
    return count;
  }

  Future<int> insertWorkplanVisit(WorkplanVisit object) async {
    var dbClient = await db;
    int count = await dbClient.insert('workplan_visit', object.toMap());
    return count;
  }

  Future<List<WorkplanVisit>> getWorkplanVisitList(int wActivityId) async {
    var wibList = await selectListWorkplanVisitList(wActivityId);
    int count = wibList.length;
    List<WorkplanVisit> dtList = <WorkplanVisit>[];
    for (int i = 0; i < count; i++) {
      //print(wibList[i].toString());
      dtList.add(WorkplanVisit.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectListWorkplanVisitList(
      int wActivityId) async {
    var dbClient = await db;
    var mapList = await dbClient.query("workplan_visit",
        where: "workplan_activity_id=?",
        whereArgs: [wActivityId],
        orderBy: "id DESC");
    return mapList;
  }

  deleteParameterProgresStatus() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_progres_status');
    return count;
  }

  deleteParameter() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter');
    return count;
  }

  deleteParameterUsaha() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_usaha');
    return count;
  }

  deleteParameterKategoriProduk() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_kategori_produk');
    return count;
  }

  deleteParameterProduk() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_produk');
    return count;
  }

  deleteParameterHasilKunjungan() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_hasil_kunjungan');
    return count;
  }

  deleteParameterTujuanKunjungan() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_tujuan_kunjungan');
    return count;
  }

  deleteWorkplanMessages() async {
    var dbClient = await db;
    int count = await dbClient.delete('workplan_messages');
    return count;
  }

  updateWorkplanVisitCheckIn(WorkplanVisit object) async {
    var dbClient = await db;
    int count = await dbClient.update('workplan_visit', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  Future<List<WorkplanVisit>> getVisitListUpdate() async {
    var wibList = await selectVisitListUpdate();
    int count = wibList.length;
    List<WorkplanVisit> dtList = <WorkplanVisit>[];
    for (int i = 0; i < count; i++) {
      // print("getVisitListUpdate->"+wibList[i].toString());
      dtList.add(WorkplanVisit.fromJson(wibList[i]));
    }
    return dtList;
  }

  Future<List<Map<String, dynamic>>> selectVisitListUpdate() async {
    var dbClient = await db;
    var mapList = await dbClient
        .query("workplan_visit", where: 'flag_update=?', whereArgs: [1]);
    // where: 'user_id=? ', whereArgs: [int.parse(userid)]);
    return mapList;
  }

  Future<ParameterTujuanKunjungan> getParameterTujuanKunjunganById(
      String id) async {
    var dbClient = await db;
    var res = await dbClient.query("parameter_tujuan_kunjungan",
        where: 'id=?', whereArgs: [int.parse(id)]);
    return new ParameterTujuanKunjungan.fromJson(res.first);
  }

  Future<ParameterHasilKunjungan> getParameterHasilKunjunganById(
      String id) async {
    var dbClient = await db;
    var res = await dbClient.query("parameter_hasil_kunjungan",
        where: 'id=?', whereArgs: [int.parse(id)]);
    return new ParameterHasilKunjungan.fromJson(res.first);
  }

  deleteParameterMappingActivity() async {
    var dbClient = await db;
    int count = await dbClient.delete('parameter_mapping_activity');
    return count;
  }

  deleteWorkplanDokumen() async {
    var dbClient = await db;
    int count = await dbClient.delete('workplan_dokumen');
    return count;
  }

  Future<List<Map<String, dynamic>>> selectListWorkplanDokumenUpdate() async {
    var dbClient = await db;
    var mapList = await dbClient
        .query("workplan_dokumen", where: 'flag_update=? ', whereArgs: [1]);
    return mapList;
  }

  Future<List<WorkplanDokumen>> getListWorkplanDokumenUpdate() async {
    var wibList = await selectListWorkplanDokumenUpdate();
    int count = wibList.length;
    List<WorkplanDokumen> dtList = <WorkplanDokumen>[];
    for (int i = 0; i < count; i++) {
      dtList.add(WorkplanDokumen.fromJson(wibList[i]));
    }
    return dtList;
  }

  deleteEnv()async {
    var dbClient = await db;
    int count = await dbClient.delete('env');
    return count;
  }
}
