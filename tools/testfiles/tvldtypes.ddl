#############################
Expected output for 'h5dump tvldtypes.h5'
#############################
HDF5 "tvldtypes.h5" {
GROUP "/" {
   DATASET "Dataset1.0" {
      DATATYPE { H5T_VLEN of H5T_STD_I32LE } 
      DATASPACE { SIMPLE ( 4 ) / ( 4 ) } 
      DATA {
         0
         10, 11
         20, 21, 22
         30, 31, 32, 33
      } 
   } 
   DATASET "Dataset1.5" {
      DATATYPE { H5T_VLEN of H5T_STD_I32BE } 
      DATASPACE { SIMPLE ( 4 ) / ( 4 ) } 
      DATA {
         0
         167772160, 184549376
         335544320, 352321536, 369098752
         503316480, 520093696, 536870912, 553648128
      } 
   } 
   DATASET "Dataset2.0" {
      DATATYPE { H5T_VLEN of H5T_IEEE_F32LE } 
      DATASPACE { SIMPLE ( 4 ) / ( 4 ) } 
      DATA {
         0
         10, 10.1
         20, 20.1, 20.2
         30, 30.1, 30.2, 30.3
      } 
   } 
   DATASET "Dataset2.5" {
      DATATYPE { H5T_VLEN of H5T_IEEE_F32BE } 
      DATASPACE { SIMPLE ( 4 ) / ( 4 ) } 
      DATA {
         0
         1.15705e-41, -6.3333e-23
         5.74883e-41, -4.29132e+08, -6.35398e-23
         8.61869e-41, -4.29787e+08, -6.36691e-23, 2.72653e+23
      } 
   } 
   DATASET "Dataset3.0" {
      DATATYPE { H5T_VLEN of H5T_STD_I32LE } 
      DATASPACE { SCALAR } 
      DATA {
         0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36,
         38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72
      } 
   } 
   DATASET "Dataset3.5" {
      DATATYPE { H5T_VLEN of H5T_STD_I32BE } 
      DATASPACE { SCALAR } 
      DATA {
         0, 33554432, 67108864, 100663296, 134217728, 167772160, 201326592,
         234881024, 268435456, 301989888, 335544320, 369098752, 402653184,
         436207616, 469762048, 503316480, 536870912, 570425344, 603979776,
         637534208, 671088640, 704643072, 738197504, 771751936, 805306368,
         838860800, 872415232, 905969664, 939524096, 973078528, 1006632960,
         1040187392, 1073741824, 1107296256, 1140850688, 1174405120, 1207959552
      } 
   } 
} 
} 
