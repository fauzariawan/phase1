// To parse this JSON data, do
//
//     final workplanInbox = workplanInboxFromJson(jsonString);

import 'dart:convert';

WorkplanInbox workplanInboxFromJson(String str) =>
    WorkplanInbox.fromJson(json.decode(str));

String workplanInboxToJson(WorkplanInbox data) => json.encode(data.toJson());

class WorkplanInbox {
  WorkplanInbox({
    required this.code,
    required this.status,
    required this.datetime,
    required this.data,
  });

  String code;
  String status;
  DateTime datetime;
  List<WorkplanInboxData> data;

  factory WorkplanInbox.fromJson(Map<String, dynamic> json) => WorkplanInbox(
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


  // WorkplanInboxData({
  //   required this.id,
  //   required this.distribusiWorkplanId,
  //   required this.activityId,
  //   required this.fullName,
  //   required this.phone,
  //   required this.location,
  //   required this.alamat,
  //   required this.rencanaKunjungan,
  //   required this.userId,
  //   required this.progresStatusId,
  //   required this.nomorWorkplan,
  //   this.createdBy,
  //   this.createdDate,
  //   this.updatedBy,
  //   required this.updatedDate,
  //   required this.kecamatan,
  //   required this.kabupaten,
  //   required this.kodepos,
  //   required this.aktualKunjungan,
  //   required this.kunjunganKe,
  //   required this.catatanKunjungan,
  //   required this.tujuanKunjunganId,
  //   required this.hasilKunjunganId,
  //   this.udfText1,
  //   this.udfText2,
  //   required this.udfNum1,
  //   this.udfOpt1,
  //   this.udfDate1,
  //   required this.kelurahan,
  //   required this.lamaUsaha,
  //   required this.jenisUsahaId,
  //   required this.npwp,
  //   required this.identityCardNo,
  //   required this.genderId,
  //   required this.genderDesc,
  //   required this.maritalStatusId,
  //   required this.maritalStatusDesc,
  //   required this.dateOfBirth,
  //   required this.placeOfBirth,
  //   this.kategoriProdukId,
  //   this.jenisProdukId,
  //   this.nominalTransaksi,
  //   this.keputusan,
  //   this.alasanTolakId,
  //   this.profOfCall,
  //   required this.companyId,
  //   this.udfTextB1,
  //   this.udfTextB2,
  //   this.udfNumB1,
  //   this.udfNumB2,
  //   this.udfDateB1,
  //   this.udfDateB2,
  //   this.udfDdlB1,
  //   this.udfDdlB2,
  //   this.personalPhone,
  //   this.personalAlamat,
  //   this.personalKecamatan,
  //   this.personalKabupaten,
  //   this.personalKodepos,
  //   this.personalKelurahan,
  //   required this.activityCode,
  //   required this.activityDescription,
  //   required this.progresStatusCode,
  //   required this.progresStatusDescription,
  //   required this.jenisUsahaCode,
  //   required this.jenisUsahaDescription,
  //   this.udfTextC1,
  //   this.udfNumC1,
  //   this.udfDateC1,
  //   this.udfTextD1,
  //   this.udfTextD2,
  //   this.udfTextD3,
  //   this.udfNumD1,
  //   this.udfNumD2,
  //   this.udfNumD3,
  //   this.udfDateD1,
  //   this.udfDateD2,
  //   this.udfDateD3,
  //   this.udfDdlD1,
  //   this.udfDdlD2,
  //   this.udfDdlD3,
  //   required this.alasanTolakDescription,
  //   required this.isCheckIn,
  //   required this.flag,
  //   this.maximumDate,
  //   required this.progresStatusIdAlter,
  //   required this.progresStatusIdAlterDescription
  // });

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
  dynamic createdBy;
  dynamic createdDate;
  dynamic updatedBy;
  dynamic updatedDate;
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
  
  WorkplanInboxData({
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
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    required this.updatedDate,
    required this.kecamatan,
    required this.kabupaten,
    required this.kodepos,
    required this.aktualKunjungan,
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
    required this.progresStatusIdAlterDescription
  });

  factory WorkplanInboxData.fromJson(Map<String, dynamic> json) =>
      WorkplanInboxData(
        id: json["id"],
        distribusiWorkplanId: json["distribusi_workplan_id"],
        activityId: json["activity_id"],
        fullName: json["full_name"],
        phone: json["phone"],
        location: json["location"],
        alamat: json["alamat"],
        rencanaKunjungan: json["rencana_kunjungan"] == null
            ? null
            : DateTime.parse(json["rencana_kunjungan"]!),
        userId: json["user_id"],
        progresStatusId: json["progres_status_id"],
        nomorWorkplan: json["nomor_workplan"],
        createdBy: json["created_by"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
        kecamatan: json["kecamatan"],
        kabupaten: json["kabupaten"],
        kodepos: json["kodepos"],
        aktualKunjungan: json["aktual_kunjungan"] == null
            ? null
            : DateTime.parse(json["aktual_kunjungan"]),
        kunjunganKe: json["kunjungan_ke"],
        catatanKunjungan: json["catatan_kunjungan"],
        tujuanKunjunganId: json["tujuan_kunjungan_id"],
        hasilKunjunganId: json["hasil_kunjungan_id"],
        udfText1: json["udf_text1"],
        udfText2: json["udf_text2"],
        udfNum1: json["udf_num1"],
        udfOpt1: json["udf_opt1"],
        udfDate1: json["udf_date1"] == null ? null: DateTime.parse(json["udf_date1"]),
        kelurahan: json["kelurahan"],
        lamaUsaha: json["lama_usaha"],
        jenisUsahaId: json["jenis_usaha_id"],
        npwp: json["npwp"],
        identityCardNo: json["identity_card_no"],
        genderId: json["gender_id"],
        genderDesc: json["gender_desc"],
        maritalStatusId: json["marital_status_id"],
        maritalStatusDesc: json["marital_status_desc"],
        dateOfBirth: json["date_of_birth"] == null
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
        udfDateB1: json["udf_date_b1"] == null ? null: DateTime.parse(json["udf_date_b1"]),
        udfDateB2: json["udf_date_b2"] == null ? null: DateTime.parse(json["udf_date_b2"]),
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
        udfDateC1: json["udf_date_c1"] == null ? null: DateTime.parse(json["udf_date_c1"]),
        udfTextD1: json["udf_text_d1"],
        udfTextD2: json["udf_text_d2"],
        udfTextD3: json["udf_text_d3"],
        udfNumD1: json["udf_num_d1"],
        udfNumD2: json["udf_num_d2"],
        udfNumD3: json["udf_num_d3"],
        udfDateD1: json["udf_date_d1"] == null ? null: DateTime.parse(json["udf_date_d1"]),
        udfDateD2: json["udf_date_d2"] == null ? null: DateTime.parse(json["udf_date_d2"]),
        udfDateD3: json["udf_date_d3"] == null ? null: DateTime.parse(json["udf_date_d3"]),
        udfDdlD1: json["udf_ddl_d1"],
        udfDdlD2: json["udf_ddl_d2"],
        udfDdlD3: json["udf_ddl_d3"],
        alasanTolakDescription: json["alasan_tolak_description"],
        isCheckIn: json["is_check_in"],
        flag:json["flag"],
        maximumDate: json["maximum_date"] == null
            ? null
            : DateTime.parse(json["maximum_date"]!),
        progresStatusIdAlter:json['progres_status_id_alter'],
        progresStatusIdAlterDescription:json['progres_status_id_alter_description'],
      );

      String strQ =  "CREATE TABLE workplan_activity("
        +"id INTEGER PRIMARY KEY, "
        +"distribusi_workplan_id INTEGER ,"
        +"activity_id INTEGER ,"
        +"full_name TEXT ,"
        +"phone TEXT ,"
        +"location TEXT ,"
        +"alamat TEXT ,"
        +"rencana_kunjungan TEXT ,"
        +"user_id INTEGER ,"
        +"progres_status_id INTEGER ,"
        +"nomor_workplan TEXT ,"
        +"nomor_workplan TEXT ,"
        +")";

  Map<String, dynamic> toJson() => {
   
        "id": id,
        "distribusi_workplan_id": distribusiWorkplanId,
        "activity_id": activityId,
        "full_name": fullName,
        "phone": phone,
        "location": location,
        "alamat": alamat,
        "rencana_kunjungan": rencanaKunjungan,
        "user_id": userId,
        "progres_status_id": progresStatusId,
        "nomor_workplan": nomorWorkplan,
        "kecamatan": kecamatan,
        "kabupaten": kabupaten,
        "kodepos": kodepos,
        "aktual_kunjungan": aktualKunjungan,
        "kunjungan_ke": kunjunganKe,
        "catatan_kunjungan": catatanKunjungan,
        "tujuan_kunjungan_id": tujuanKunjunganId,
        "hasil_kunjungan_id": hasilKunjunganId,
        "udf_text1": udfText1,
        "udf_text2": udfText2,
        "udf_num1": udfNum1,
        "udf_opt1": udfOpt1,
        "udf_date1": udfDate1,
        "kelurahan": kelurahan,
        "lama_usaha": lamaUsaha,
        "jenis_usaha_id": jenisUsahaId,
        "npwp": npwp,
        "identity_card_no": identityCardNo,
        "gender_id": genderId,
        "gender_desc": genderDesc,
        "marital_status_id": maritalStatusId,
        "marital_status_desc": maritalStatusDesc,
        "date_of_birth": dateOfBirth,
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
        "udf_date_b1": udfDateB1,
        "udf_date_b2": udfDateB2,
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
        "udf_date_c1": udfDateC1,
        "udf_text_d1": udfTextD1,
        "udf_text_d2": udfTextD2,
        "udf_text_d3": udfTextD3,
        "udf_num_d1": udfNumD1,
        "udf_num_d2": udfNumD2,
        "udf_num_d3": udfNumD3,
        "udf_date_d1": udfDateD1,
        "udf_date_d2": udfDateD2,
        "udf_date_d3": udfDateD3,
        "udf_ddl_d1": udfDdlD1,
        "udf_ddl_d2": udfDdlD2,
        "udf_ddl_d3": udfDdlD3,
        "alasan_tolak_description" : alasanTolakDescription,
        "is_check_in": isCheckIn,
        "flag":flag,
        "maximum_date":maximumDate,
        "progres_status_id_alter":progresStatusIdAlter,
        "progres_status_id_alter_description":progresStatusIdAlterDescription,
        "created_by": createdBy,
        "created_date": createdDate,
        "updated_by": updatedBy,
        "updated_date": updatedDate.toIso8601String(),
      };
}
