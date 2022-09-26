// To parse this JSON data, do
//
//     final workplanInbox = workplanInboxFromJson(jsonString);

import 'dart:convert';

WorkplanInboxModel workplanInboxFromJson(String str) =>
    WorkplanInboxModel.fromJson(json.decode(str));

String workplanInboxToJson(WorkplanInboxModel data) =>
    json.encode(data.toJson());

class WorkplanInboxModel {
  WorkplanInboxModel({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<WorkplanInboxData> data;

  factory WorkplanInboxModel.fromJson(Map<String, dynamic> json) =>
      WorkplanInboxModel(
        code: json["code"],
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        data: List<WorkplanInboxData>.from(
            json["data"].map((x) => WorkplanInboxData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "datetime": datetime.toIso8601String(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class WorkplanInboxData {
  dynamic workplanActivityPk;
  int id;
  int distribusiWorkplanId;
  int activityId;
  String fullName;
  String phone;
  String location;
  String alamat;
  dynamic rencanaKunjungan;
  int userId;
  int progresStatusId;
  String nomorWorkplan;
  // dynamic createdBy;
  // dynamic createdDate;
  // dynamic updatedBy;
  // dynamic updatedDate;
  String kecamatan;
  String kabupaten;
  String kodepos;
  dynamic aktualKunjungan;
  int kunjunganKe;
  String catatanKunjungan;
  int tujuanKunjunganId;
  int hasilKunjunganId;
  dynamic udfText1;
  dynamic udfText2;
  int udfNum1;
  dynamic udfOpt1;
  dynamic udfDate1;
  String kelurahan;
  dynamic lamaUsaha;
  int jenisUsahaId;
  String npwp;
  String identityCardNo;
  int genderId;
  String genderDesc;
  int maritalStatusId;
  String maritalStatusDesc;
  dynamic dateOfBirth;
  String placeOfBirth;
  dynamic kategoriProdukId;
  dynamic jenisProdukId;
  dynamic nominalTransaksi;
  dynamic keputusan;
  dynamic alasanTolakId;
  dynamic profOfCall;
  int companyId;
  dynamic udfTextB1;
  dynamic udfTextB2;
  dynamic udfNumB1;
  dynamic udfNumB2;
  dynamic udfDateB1;
  dynamic udfDateB2;
  dynamic udfDdlB1;
  dynamic udfDdlB2;
  dynamic personalPhone;
  dynamic personalAlamat;
  dynamic personalKecamatan;
  dynamic personalKabupaten;
  dynamic personalKodepos;
  dynamic personalKelurahan;
  String activityCode;
  String activityDescription;
  String progresStatusCode;
  String progresStatusDescription;
  String jenisUsahaCode;
  String jenisUsahaDescription;
  dynamic udfTextC1;
  dynamic udfNumC1;
  dynamic udfDateC1;
  dynamic udfTextD1;
  dynamic udfTextD2;
  dynamic udfTextD3;
  dynamic udfNumD1;
  dynamic udfNumD2;
  dynamic udfNumD3;
  dynamic udfDateD1;
  dynamic udfDateD2;
  dynamic udfDateD3;
  dynamic udfDdlD1;
  dynamic udfDdlD2;
  dynamic udfDdlD3;
  String alasanTolakDescription;
  String isCheckIn;
  int flag;
  dynamic maximumDate;
  int progresStatusIdAlter;
  String progresStatusIdAlterDescription;
  String nomorWorkplanInbox;
  int flagUpdate;
  dynamic receiveDate;
  int flagUpdatePersonal;
  int flagUpdateProduk;
  int flagUpdateUdf;
  dynamic maksimalUmurDate;
  // int progresStatusIdReal;
  // String updateDataFor;//1 = receive inbox, 2 =
  /*flagUpdate 
    1 = receive inbox 
    2 = workplan input 
    3 = personal data
    4 = produk 
    5 = udf 
    6 = check in
    7 = check out 
    

  */

  WorkplanInboxData({
    this.workplanActivityPk,
    required this.id,
    required this.distribusiWorkplanId,
    required this.activityId,
    required this.fullName,
    required this.phone,
    required this.location,
    required this.alamat,
    required this.rencanaKunjungan,
    required this.userId,
    required this.progresStatusId,
    required this.nomorWorkplan,
    // this.createdBy,
    // this.createdDate,
    // this.updatedBy,
    // required this.updatedDate,
    required this.kecamatan,
    required this.kabupaten,
    required this.kodepos,
    this.aktualKunjungan,
    required this.kunjunganKe,
    required this.catatanKunjungan,
    required this.tujuanKunjunganId,
    required this.hasilKunjunganId,
    this.udfText1,
    this.udfText2,
    required this.udfNum1,
    this.udfOpt1,
    this.udfDate1,
    required this.kelurahan,
    required this.lamaUsaha,
    required this.jenisUsahaId,
    required this.npwp,
    required this.identityCardNo,
    required this.genderId,
    required this.genderDesc,
    required this.maritalStatusId,
    required this.maritalStatusDesc,
    required this.dateOfBirth,
    required this.placeOfBirth,
    this.kategoriProdukId,
    this.jenisProdukId,
    this.nominalTransaksi,
    this.keputusan,
    this.alasanTolakId,
    this.profOfCall,
    required this.companyId,
    this.udfTextB1,
    this.udfTextB2,
    this.udfNumB1,
    this.udfNumB2,
    this.udfDateB1,
    this.udfDateB2,
    this.udfDdlB1,
    this.udfDdlB2,
    this.personalPhone,
    this.personalAlamat,
    this.personalKecamatan,
    this.personalKabupaten,
    this.personalKodepos,
    this.personalKelurahan,
    required this.activityCode,
    required this.activityDescription,
    required this.progresStatusCode,
    required this.progresStatusDescription,
    required this.jenisUsahaCode,
    required this.jenisUsahaDescription,
    this.udfTextC1,
    this.udfNumC1,
    this.udfDateC1,
    this.udfTextD1,
    this.udfTextD2,
    this.udfTextD3,
    this.udfNumD1,
    this.udfNumD2,
    this.udfNumD3,
    this.udfDateD1,
    this.udfDateD2,
    this.udfDateD3,
    this.udfDdlD1,
    this.udfDdlD2,
    this.udfDdlD3,
    required this.alasanTolakDescription,
    required this.isCheckIn,
    required this.flag,
    this.maximumDate,
    required this.progresStatusIdAlter,
    required this.progresStatusIdAlterDescription,
    required this.nomorWorkplanInbox,
    required this.flagUpdate,
    this.receiveDate,
    required this.flagUpdatePersonal,
    required this.flagUpdateProduk,
    required this.flagUpdateUdf,
    this.maksimalUmurDate
    // required this.progresStatusIdReal
  });

  factory WorkplanInboxData.fromJson(Map<String, dynamic> json) =>
      WorkplanInboxData(
        workplanActivityPk: json["workplan_activity_pk"],
        id: json["id"],
        distribusiWorkplanId: json["distribusi_workplan_id"],
        activityId: json["activity_id"],
        fullName: json["full_name"],
        phone: json["phone"],
        location: json["location"],
        alamat: json["alamat"],
        rencanaKunjungan: json["rencana_kunjungan"] == "null" ||
                json["rencana_kunjungan"] == null ||
                json["rencana_kunjungan"] == ""
            ? null
            : DateTime.parse(json["rencana_kunjungan"]),
        userId: json["user_id"],
        progresStatusId: json["progres_status_id"],
        nomorWorkplan: json["nomor_workplan"],
        kecamatan: json["kecamatan"],
        kabupaten: json["kabupaten"],
        kodepos: json["kodepos"],
        aktualKunjungan: json["aktual_kunjungan"] == "null" ||
                json["aktual_kunjungan"] == null ||
                json["aktual_kunjungan"] == ""
            ? null
            : DateTime.parse(json["aktual_kunjungan"]),
        kunjunganKe: json["kunjungan_ke"],
        catatanKunjungan: json["catatan_kunjungan"],
        tujuanKunjunganId: json["tujuan_kunjungan_id"],
        hasilKunjunganId: json["hasil_kunjungan_id"],
        udfText1: json["udf_text1"],
        udfText2: json["udf_text2"],
        udfNum1: json["udf_num1"] == "" ? null : json["udf_num1"],
        udfOpt1: json["udf_opt1"],
        udfDate1: json["udf_date1"] == null || json["udf_date1"] == ""
            ? null
            : DateTime.parse(json["udf_date1"]),
        kelurahan: json["kelurahan"],
        lamaUsaha: json["lama_usaha"],
        jenisUsahaId: json["jenis_usaha_id"],
        npwp: json["npwp"],
        identityCardNo: json["identity_card_no"],
        genderId: json["gender_id"],
        genderDesc: json["gender_desc"],
        maritalStatusId: json["marital_status_id"],
        maritalStatusDesc: json["marital_status_desc"],
        dateOfBirth:
            json["date_of_birth"] == null || json["date_of_birth"] == ""
                ? null
                : DateTime.parse(json["date_of_birth"]),
        placeOfBirth: json["place_of_birth"],
        kategoriProdukId: json["kategori_produk_id"],
        jenisProdukId: json["jenis_produk_id"],
        nominalTransaksi: json["nominal_transaksi"],
        keputusan: json["keputusan"],
        alasanTolakId: json["alasan_tolak_id"],
        profOfCall: json["prof_of_call"],
        companyId: json["company_id"],
        udfTextB1: json["udf_text_b1"],
        udfTextB2: json["udf_text_b2"],
        udfNumB1: json["udf_num_b1"],
        udfNumB2: json["udf_num_b2"],
        udfDateB1: json["udf_date_b1"] == null || json["udf_date_b1"] == ""
            ? null
            : DateTime.parse(json["udf_date_b1"]),
        udfDateB2: json["udf_date_b2"] == null || json["udf_date_b2"] == ""
            ? null
            : DateTime.parse(json["udf_date_b2"]),
        udfDdlB1: json["udf_ddl_b1"],
        udfDdlB2: json["udf_ddl_b2"],
        personalPhone: json["personal_phone"],
        personalAlamat: json["personal_alamat"],
        personalKecamatan: json["personal_kecamatan"],
        personalKabupaten: json["personal_kabupaten"],
        personalKodepos: json["personal_kodepos"],
        personalKelurahan: json["personal_kelurahan"],
        activityCode: json["activity_code"],
        activityDescription: json["activity_description"],
        progresStatusCode: json["progres_status_code"],
        progresStatusDescription: json["progres_status_description"],
        jenisUsahaCode: json["jenis_usaha_code"],
        jenisUsahaDescription: json["jenis_usaha_description"],
        udfTextC1: json["udf_text_c1"],
        udfNumC1: json["udf_num_c1"],
        udfDateC1: json["udf_date_c1"] == null || json["udf_date_c1"] == ""
            ? null
            : DateTime.parse(json["udf_date_c1"]),
        udfTextD1: json["udf_text_d1"],
        udfTextD2: json["udf_text_d2"],
        udfTextD3: json["udf_text_d3"],
        udfNumD1: json["udf_num_d1"],
        udfNumD2: json["udf_num_d2"],
        udfNumD3: json["udf_num_d3"],
        udfDateD1: json["udf_date_d1"] == null || json["udf_date_d1"] == ""
            ? null
            : DateTime.parse(json["udf_date_d1"]),
        udfDateD2: json["udf_date_d2"] == null || json["udf_date_d2"] == ""
            ? null
            : DateTime.parse(json["udf_date_d2"]),
        udfDateD3: json["udf_date_d3"] == null || json["udf_date_d3"] == ""
            ? null
            : DateTime.parse(json["udf_date_d3"]),
        udfDdlD1: json["udf_ddl_d1"],
        udfDdlD2: json["udf_ddl_d2"],
        udfDdlD3: json["udf_ddl_d3"],
        alasanTolakDescription: json["alasan_tolak_description"],
        isCheckIn: json["is_check_in"],
        flag: json["flag"],
        maximumDate: json["maximum_date"] == null || json["maximum_date"] == ""
            ? null
            : DateTime.parse(json["maximum_date"]!),
        progresStatusIdAlter: json['progres_status_id_alter'],
        progresStatusIdAlterDescription:
            json['progres_status_id_alter_description'],
        nomorWorkplanInbox: json['nomor_workplan_inbox'],
        flagUpdate: json['flag_update'],
        receiveDate: json["receive_date"] == null || json["receive_date"] == ""
            ? null
            : DateTime.parse(json["receive_date"]!),
        flagUpdatePersonal: json['flag_update_personal'],
        flagUpdateProduk: json['flag_update_personal'],
        flagUpdateUdf: json['flag_update_personal'],
        maksimalUmurDate: json['maksimal_umur_date']
        // progresStatusIdReal: json['progres_status_id_real']
      );

  Map<String, dynamic> toJson() => {
        "workplan_activity_pk": workplanActivityPk,
        "id": id,
        "distribusi_workplan_id": distribusiWorkplanId,
        "activity_id": activityId,
        "full_name": fullName,
        "phone": phone,
        "location": location,
        "alamat": alamat,
        "rencana_kunjungan": rencanaKunjungan == null ? null  : rencanaKunjungan.toIso8601String(),
        "user_id": userId,
        "progres_status_id": progresStatusId,
        "nomor_workplan": nomorWorkplan,
        "kecamatan": kecamatan,
        "kabupaten": kabupaten,
        "kodepos": kodepos,
        "aktual_kunjungan":  aktualKunjungan == null ? null : aktualKunjungan.toIso8601String(),
        "kunjungan_ke": kunjunganKe,
        "catatan_kunjungan": catatanKunjungan,
        "tujuan_kunjungan_id": tujuanKunjunganId,
        "hasil_kunjungan_id": hasilKunjunganId,
        "udf_text1": udfText1,
        "udf_text2": udfText2,
        "udf_num1": udfNum1,
        "udf_opt1": udfOpt1,
        "udf_date1": udfDate1 == null ? null : udfDate1.toIso8601String(),
        "kelurahan": kelurahan,
        "lama_usaha": lamaUsaha,
        "jenis_usaha_id": jenisUsahaId,
        "npwp": npwp,
        "identity_card_no": identityCardNo,
        "gender_id": genderId,
        "gender_desc": genderDesc,
        "marital_status_id": maritalStatusId,
        "marital_status_desc": maritalStatusDesc,
        "date_of_birth":  dateOfBirth == null ? null : dateOfBirth.toIso8601String(),
        "place_of_birth": placeOfBirth,
        "kategori_produk_id": kategoriProdukId,
        "jenis_produk_id": jenisProdukId,
        "nominal_transaksi": nominalTransaksi,
        "keputusan": keputusan,
        "alasan_tolak_id": alasanTolakId,
        "prof_of_call": profOfCall,
        "company_id": companyId,
        "udf_text_b1": udfTextB1,
        "udf_text_b2": udfTextB2,
        "udf_num_b1": udfNumB1,
        "udf_num_b2": udfNumB2,
        "udf_date_b1": udfDateB1 == null ? null : udfDateB1.toIso8601String(),
        "udf_date_b2": udfDateB2 == null ? null : udfDateB2.toIso8601String(),
        "udf_ddl_b1": udfDdlB1,
        "udf_ddl_b2": udfDdlB2,
        "personal_phone": personalPhone,
        "personal_alamat": personalAlamat,
        "personal_kecamatan": personalKecamatan,
        "personal_kabupaten": personalKabupaten,
        "personal_kodepos": personalKodepos,
        "personal_kelurahan": personalKelurahan,
        "activity_code": activityCode,
        "activity_description": activityDescription,
        "progres_status_code": progresStatusCode,
        "progres_status_description": progresStatusDescription,
        "jenis_usaha_code": jenisUsahaCode,
        "jenis_usaha_description": jenisUsahaDescription,
        "udf_text_c1": udfTextC1,
        "udf_num_c1": udfNumC1,
        "udf_date_c1": udfDateC1 == null ? null : udfDateC1.toIso8601String(),
        "udf_text_d1": udfTextD1,
        "udf_text_d2": udfTextD2,
        "udf_text_d3": udfTextD3,
        "udf_num_d1": udfNumD1,
        "udf_num_d2": udfNumD2,
        "udf_num_d3": udfNumD3,
        "udf_date_d1": udfDateD1 == null ? null : udfDateD1.toIso8601String(),
        "udf_date_d2": udfDateD2 == null ? null : udfDateD2.toIso8601String(),
        "udf_date_d3": udfDateD3 == null ? null : udfDateD3.toIso8601String(),
        "udf_ddl_d1": udfDdlD1,
        "udf_ddl_d2": udfDdlD2,
        "udf_ddl_d3": udfDdlD3,
        "alasan_tolak_description": alasanTolakDescription,
        "is_check_in": isCheckIn, 
        "flag": flag,
        "maximum_date": maximumDate == null ? null : maximumDate.toIso8601String(),
        "progres_status_id_alter": progresStatusIdAlter,
        "progres_status_id_alter_description": progresStatusIdAlterDescription,
        "nomor_workplan_inbox": nomorWorkplanInbox,
        "flag_update": flagUpdate,
        "receive_date": receiveDate == null ? null : receiveDate.toIso8601String(),
        "flag_update_personal": flagUpdatePersonal,
        "flag_update_produk": flagUpdateProduk,
        "flag_update_udf": flagUpdateUdf,
        "maksimal_umur_date": maksimalUmurDate == null ? null : maksimalUmurDate.toIso8601String(),
        
        // "progres_status_id_real":progresStatusIdReal
      };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["workplan_activity_pk"] = workplanActivityPk;
    map["id"] = id;
    map["distribusi_workplan_id"] = distribusiWorkplanId;
    map["activity_id"] = activityId;
    map["full_name"] = fullName;
    map["phone"] = phone;
    map["location"] = location;
    map["alamat"] = alamat;
    map["rencana_kunjungan"] = rencanaKunjungan == null ? "" : rencanaKunjungan.toString();
    map["user_id"] = userId;
    map["progres_status_id"] = progresStatusId;
    map["nomor_workplan"] = nomorWorkplan;
    map["kecamatan"] = kecamatan;
    map["kabupaten"] = kabupaten;
    map["kodepos"] = kodepos;
    map["aktual_kunjungan"] = aktualKunjungan == null ? "" : aktualKunjungan.toString();
    map["kunjungan_ke"] = kunjunganKe;
    map["catatan_kunjungan"] = catatanKunjungan;
    map["tujuan_kunjungan_id"] = tujuanKunjunganId;
    map["hasil_kunjungan_id"] = hasilKunjunganId;
    map["udf_text1"] = udfText1;
    map["udf_text2"] = udfText2;
    map["udf_num1"] = udfNum1;
    map["udf_opt1"] = udfOpt1;
    map["udf_date1"] = udfDate1 == null ? "" : udfDate1.toString();
    map["kelurahan"] = kelurahan;
    map["lama_usaha"] = lamaUsaha;
    map["jenis_usaha_id"] = jenisUsahaId;
    map["npwp"] = npwp;
    map["identity_card_no"] = identityCardNo;
    map["gender_id"] = genderId;
    map["gender_desc"] = genderDesc;
    map["marital_status_id"] = maritalStatusId;
    map["marital_status_desc"] = maritalStatusDesc;
    map["date_of_birth"] = dateOfBirth == null ? "" : dateOfBirth.toString();
    map["place_of_birth"] = placeOfBirth;
    map["kategori_produk_id"] = kategoriProdukId;
    map["jenis_produk_id"] = jenisProdukId;
    map["nominal_transaksi"] = nominalTransaksi;
    map["keputusan"] = keputusan;
    map["alasan_tolak_id"] = alasanTolakId;
    map["prof_of_call"] = profOfCall;
    map["company_id"] = companyId;
    map["udf_text_b1"] = udfTextB1;
    map["udf_text_b2"] = udfTextB2;
    map["udf_num_b1"] = udfNumB1;
    map["udf_num_b2"] = udfNumB2;
    map["udf_date_b1"] = udfDateB1 == null ? "" : udfDateB1.toString();
    map["udf_date_b2"] = udfDateB2 == null ? "" : udfDateB2.toString();
    map["udf_ddl_b1"] = udfDdlB1;
    map["udf_ddl_b2"] = udfDdlB2;
    map["personal_phone"] = personalPhone;
    map["personal_alamat"] = personalAlamat;
    map["personal_kecamatan"] = personalKecamatan;
    map["personal_kabupaten"] = personalKabupaten;
    map["personal_kodepos"] = personalKodepos;
    map["personal_kelurahan"] = personalKelurahan;
    map["activity_code"] = activityCode;
    map["activity_description"] = activityDescription;
    map["progres_status_code"] = progresStatusCode;
    map["progres_status_description"] = progresStatusDescription;
    map["jenis_usaha_code"] = jenisUsahaCode;
    map["jenis_usaha_description"] = jenisUsahaDescription;
    map["udf_text_c1"] = udfTextC1;
    map["udf_num_c1"] = udfNumC1;
    map["udf_date_c1"] = udfDateC1 == null ? "" : udfDateC1.toString();
    map["udf_text_d1"] = udfTextD1;
    map["udf_text_d2"] = udfTextD2;
    map["udf_text_d3"] = udfTextD3;
    map["udf_num_d1"] = udfNumD1;
    map["udf_num_d2"] = udfNumD2;
    map["udf_num_d3"] = udfNumD3;
    map["udf_date_d1"] = udfDateD1 == null ? "" : udfDateD1.toString();
    map["udf_date_d2"] = udfDateD2 == null ? "" : udfDateD2.toString();
    map["udf_date_d3"] = udfDateD3 == null ? "" : udfDateD3.toString();
    map["udf_ddl_d1"] = udfDdlD1;
    map["udf_ddl_d2"] = udfDdlD2;
    map["udf_ddl_d3"] = udfDdlD3;
    map["alasan_tolak_description"] = alasanTolakDescription;
    map["is_check_in"] = isCheckIn;
    map["flag"] = flag;
    map["maximum_date"] = maximumDate == null ? "" : maximumDate.toString();
    map["progres_status_id_alter"] = progresStatusIdAlter;
    map["progres_status_id_alter_description"] = progresStatusIdAlterDescription;
    map["nomor_workplan_inbox"] = nomorWorkplanInbox;
    map["flag_update"] = flagUpdate;
    map["receive_date"] = receiveDate == null ? "" : receiveDate.toString();
    map["flag_update_personal"] = flagUpdatePersonal;
    map["flag_update_produk"] = flagUpdateProduk;
    map["flag_update_udf"] = flagUpdateUdf;
    map["maksimal_umur_date"]= maksimalUmurDate == null ? "" : maksimalUmurDate.toString();;
    // map[ "progres_status_id_real"] = progresStatusIdReal;
    return map;
  }
}
