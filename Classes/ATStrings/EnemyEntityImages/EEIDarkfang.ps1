using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EEI DARKFANG
#
###############################################################################

Class EEIDarkfang : EEIInternalBase {
    EEIDarkfang() : base() {
        $this.ColorMap[0]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[1]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[2]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[3]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[4]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[5]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[6]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[7]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[8]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[9]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[10]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[11]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[12]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[13]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[14]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[15]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[16]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[17]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[18]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[19]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[20]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[21]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[22]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[23]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[24]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[25]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[26]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[27]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[28]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[29]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[30]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[31]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[32]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[33]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[34]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[35]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[36]  = [ATBackgroundColor24None]::new() # End Row 0
        $this.ColorMap[37]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[38]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[39]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[40]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[41]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[42]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[43]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[44]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[45]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[46]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[47]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[48]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[49]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[50]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[51]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[52]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[53]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[54]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[55]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[56]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[57]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[58]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[59]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[60]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[61]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[62]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[63]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[64]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[65]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[66]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[67]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[68]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[69]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[70]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[71]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[72]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[73]  = [ATBackgroundColor24None]::new() # End Row 1
        $this.ColorMap[74]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[75]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[76]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[77]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[78]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[79]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[80]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[81]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[82]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[83]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[84]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[85]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[86]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[87]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[88]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[89]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[90]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[91]  = [CCAppleIndigoLight24]::new()
        $this.ColorMap[92]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[93]  = [CCAppleIndigoLight24]::new()
        $this.ColorMap[94]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[95]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[96]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[97]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[98]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[99]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[100] = [ATBackgroundColor24None]::new()
        $this.ColorMap[101] = [ATBackgroundColor24None]::new()
        $this.ColorMap[102] = [ATBackgroundColor24None]::new()
        $this.ColorMap[103] = [ATBackgroundColor24None]::new()
        $this.ColorMap[104] = [ATBackgroundColor24None]::new()
        $this.ColorMap[105] = [ATBackgroundColor24None]::new()
        $this.ColorMap[106] = [ATBackgroundColor24None]::new()
        $this.ColorMap[107] = [ATBackgroundColor24None]::new()
        $this.ColorMap[108] = [ATBackgroundColor24None]::new()
        $this.ColorMap[109] = [ATBackgroundColor24None]::new()
        $this.ColorMap[110] = [ATBackgroundColor24None]::new() # End Row 2
        $this.ColorMap[111] = [ATBackgroundColor24None]::new()
        $this.ColorMap[112] = [ATBackgroundColor24None]::new()
        $this.ColorMap[113] = [ATBackgroundColor24None]::new()
        $this.ColorMap[114] = [ATBackgroundColor24None]::new()
        $this.ColorMap[115] = [ATBackgroundColor24None]::new()
        $this.ColorMap[116] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[117] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[118] = [ATBackgroundColor24None]::new()
        $this.ColorMap[119] = [ATBackgroundColor24None]::new()
        $this.ColorMap[120] = [ATBackgroundColor24None]::new()
        $this.ColorMap[121] = [ATBackgroundColor24None]::new()
        $this.ColorMap[122] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[123] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[124] = [ATBackgroundColor24None]::new()
        $this.ColorMap[125] = [ATBackgroundColor24None]::new()
        $this.ColorMap[126] = [ATBackgroundColor24None]::new()
        $this.ColorMap[127] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[128] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[129] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[130] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[131] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[132] = [ATBackgroundColor24None]::new()
        $this.ColorMap[133] = [ATBackgroundColor24None]::new()
        $this.ColorMap[134] = [ATBackgroundColor24None]::new()
        $this.ColorMap[135] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[136] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[137] = [ATBackgroundColor24None]::new()
        $this.ColorMap[138] = [ATBackgroundColor24None]::new()
        $this.ColorMap[139] = [ATBackgroundColor24None]::new()
        $this.ColorMap[140] = [ATBackgroundColor24None]::new()
        $this.ColorMap[141] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[142] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[143] = [ATBackgroundColor24None]::new()
        $this.ColorMap[144] = [ATBackgroundColor24None]::new()
        $this.ColorMap[145] = [ATBackgroundColor24None]::new()
        $this.ColorMap[146] = [ATBackgroundColor24None]::new()
        $this.ColorMap[147] = [ATBackgroundColor24None]::new() # End Row 3
        $this.ColorMap[148] = [ATBackgroundColor24None]::new()
        $this.ColorMap[149] = [ATBackgroundColor24None]::new()
        $this.ColorMap[150] = [ATBackgroundColor24None]::new()
        $this.ColorMap[151] = [ATBackgroundColor24None]::new()
        $this.ColorMap[152] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[153] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[154] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[155] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[156] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[157] = [ATBackgroundColor24None]::new()
        $this.ColorMap[158] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[159] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[160] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[161] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[162] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[163] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[164] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[165] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[166] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[167] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[168] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[169] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[170] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[171] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[172] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[173] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[174] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[175] = [ATBackgroundColor24None]::new()
        $this.ColorMap[176] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[177] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[178] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[179] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[180] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[181] = [ATBackgroundColor24None]::new()
        $this.ColorMap[182] = [ATBackgroundColor24None]::new()
        $this.ColorMap[183] = [ATBackgroundColor24None]::new()
        $this.ColorMap[184] = [ATBackgroundColor24None]::new() # End Row 4
        $this.ColorMap[185] = [ATBackgroundColor24None]::new()
        $this.ColorMap[186] = [ATBackgroundColor24None]::new()
        $this.ColorMap[187] = [ATBackgroundColor24None]::new()
        $this.ColorMap[188] = [ATBackgroundColor24None]::new()
        $this.ColorMap[189] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[190] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[191] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[192] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[193] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[194] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[195] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[196] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[197] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[198] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[199] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[200] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[201] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[202] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[203] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[204] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[205] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[206] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[207] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[208] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[209] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[210] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[211] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[212] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[213] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[214] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[215] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[216] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[217] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[218] = [ATBackgroundColor24None]::new()
        $this.ColorMap[219] = [ATBackgroundColor24None]::new()
        $this.ColorMap[220] = [ATBackgroundColor24None]::new()
        $this.ColorMap[221] = [ATBackgroundColor24None]::new() # End Row 5
        $this.ColorMap[222] = [ATBackgroundColor24None]::new()
        $this.ColorMap[223] = [ATBackgroundColor24None]::new()
        $this.ColorMap[224] = [ATBackgroundColor24None]::new()
        $this.ColorMap[225] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[226] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[227] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[228] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[229] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[230] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[231] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[232] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[233] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[234] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[235] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[236] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[237] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[238] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[239] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[240] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[241] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[242] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[243] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[244] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[245] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[246] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[247] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[248] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[249] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[250] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[251] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[252] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[253] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[254] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[255] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[256] = [ATBackgroundColor24None]::new()
        $this.ColorMap[257] = [ATBackgroundColor24None]::new()
        $this.ColorMap[258] = [ATBackgroundColor24None]::new() # End Row 6
        $this.ColorMap[259] = [ATBackgroundColor24None]::new()
        $this.ColorMap[260] = [ATBackgroundColor24None]::new()
        $this.ColorMap[261] = [ATBackgroundColor24None]::new()
        $this.ColorMap[262] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[263] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[264] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[265] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[266] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[267] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[268] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[269] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[270] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[271] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[272] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[273] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[274] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[275] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[276] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[277] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[278] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[279] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[280] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[281] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[282] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[283] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[284] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[285] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[286] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[287] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[288] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[289] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[290] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[291] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[292] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[293] = [ATBackgroundColor24None]::new()
        $this.ColorMap[294] = [ATBackgroundColor24None]::new()
        $this.ColorMap[295] = [ATBackgroundColor24None]::new() # End Row 7
        $this.ColorMap[296] = [ATBackgroundColor24None]::new()
        $this.ColorMap[297] = [ATBackgroundColor24None]::new()
        $this.ColorMap[298] = [ATBackgroundColor24None]::new()
        $this.ColorMap[299] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[300] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[301] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[302] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[303] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[304] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[305] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[306] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[307] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[308] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[309] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[310] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[311] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[312] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[313] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[314] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[315] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[316] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[317] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[318] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[319] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[320] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[321] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[322] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[323] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[324] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[325] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[326] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[327] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[328] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[329] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[330] = [ATBackgroundColor24None]::new()
        $this.ColorMap[331] = [ATBackgroundColor24None]::new()
        $this.ColorMap[332] = [ATBackgroundColor24None]::new() # End Row 8
        $this.ColorMap[333] = [ATBackgroundColor24None]::new()
        $this.ColorMap[334] = [ATBackgroundColor24None]::new()
        $this.ColorMap[335] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[336] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[337] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[338] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[339] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[340] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[341] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[342] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[343] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[344] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[345] = [ATBackgroundColor24None]::new()
        $this.ColorMap[346] = [ATBackgroundColor24None]::new()
        $this.ColorMap[347] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[348] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[349] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[350] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[351] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[352] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[353] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[354] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[355] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[356] = [ATBackgroundColor24None]::new()
        $this.ColorMap[357] = [ATBackgroundColor24None]::new()
        $this.ColorMap[358] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[359] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[360] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[361] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[362] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[363] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[364] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[365] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[366] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[367] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[368] = [ATBackgroundColor24None]::new()
        $this.ColorMap[369] = [ATBackgroundColor24None]::new() # End Row 9
        $this.ColorMap[370] = [ATBackgroundColor24None]::new()
        $this.ColorMap[371] = [ATBackgroundColor24None]::new()
        $this.ColorMap[372] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[373] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[374] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[375] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[376] = [ATBackgroundColor24None]::new()
        $this.ColorMap[377] = [ATBackgroundColor24None]::new()
        $this.ColorMap[378] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[379] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[380] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[381] = [ATBackgroundColor24None]::new()
        $this.ColorMap[382] = [ATBackgroundColor24None]::new()
        $this.ColorMap[383] = [ATBackgroundColor24None]::new()
        $this.ColorMap[384] = [ATBackgroundColor24None]::new()
        $this.ColorMap[385] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[386] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[387] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[388] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[389] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[390] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[391] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[392] = [ATBackgroundColor24None]::new()
        $this.ColorMap[393] = [ATBackgroundColor24None]::new()
        $this.ColorMap[394] = [ATBackgroundColor24None]::new()
        $this.ColorMap[395] = [ATBackgroundColor24None]::new()
        $this.ColorMap[396] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[397] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[398] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[399] = [ATBackgroundColor24None]::new()
        $this.ColorMap[400] = [ATBackgroundColor24None]::new()
        $this.ColorMap[401] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[402] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[403] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[404] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[405] = [ATBackgroundColor24None]::new()
        $this.ColorMap[406] = [ATBackgroundColor24None]::new() # End Row 10
        $this.ColorMap[407] = [ATBackgroundColor24None]::new()
        $this.ColorMap[408] = [ATBackgroundColor24None]::new()
        $this.ColorMap[409] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[410] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[411] = [ATBackgroundColor24None]::new()
        $this.ColorMap[412] = [ATBackgroundColor24None]::new()
        $this.ColorMap[413] = [ATBackgroundColor24None]::new()
        $this.ColorMap[414] = [ATBackgroundColor24None]::new()
        $this.ColorMap[415] = [ATBackgroundColor24None]::new()
        $this.ColorMap[416] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[417] = [ATBackgroundColor24None]::new()
        $this.ColorMap[418] = [ATBackgroundColor24None]::new()
        $this.ColorMap[419] = [ATBackgroundColor24None]::new()
        $this.ColorMap[420] = [CCAppleRedDark24]::new()
        $this.ColorMap[421] = [ATBackgroundColor24None]::new()
        $this.ColorMap[422] = [ATBackgroundColor24None]::new()
        $this.ColorMap[423] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[424] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[425] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[426] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[427] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[428] = [ATBackgroundColor24None]::new()
        $this.ColorMap[429] = [ATBackgroundColor24None]::new()
        $this.ColorMap[430] = [CCAppleRedDark24]::new()
        $this.ColorMap[431] = [ATBackgroundColor24None]::new()
        $this.ColorMap[432] = [ATBackgroundColor24None]::new()
        $this.ColorMap[433] = [ATBackgroundColor24None]::new()
        $this.ColorMap[434] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[435] = [ATBackgroundColor24None]::new()
        $this.ColorMap[436] = [ATBackgroundColor24None]::new()
        $this.ColorMap[437] = [ATBackgroundColor24None]::new()
        $this.ColorMap[438] = [ATBackgroundColor24None]::new()
        $this.ColorMap[439] = [ATBackgroundColor24None]::new()
        $this.ColorMap[440] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[441] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[442] = [ATBackgroundColor24None]::new()
        $this.ColorMap[443] = [ATBackgroundColor24None]::new() # End Row 11
        $this.ColorMap[444] = [ATBackgroundColor24None]::new()
        $this.ColorMap[445] = [ATBackgroundColor24None]::new()
        $this.ColorMap[446] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[447] = [ATBackgroundColor24None]::new()
        $this.ColorMap[448] = [ATBackgroundColor24None]::new()
        $this.ColorMap[449] = [ATBackgroundColor24None]::new()
        $this.ColorMap[450] = [ATBackgroundColor24None]::new()
        $this.ColorMap[451] = [ATBackgroundColor24None]::new()
        $this.ColorMap[452] = [ATBackgroundColor24None]::new()
        $this.ColorMap[453] = [ATBackgroundColor24None]::new()
        $this.ColorMap[454] = [ATBackgroundColor24None]::new()
        $this.ColorMap[455] = [ATBackgroundColor24None]::new()
        $this.ColorMap[456] = [ATBackgroundColor24None]::new()
        $this.ColorMap[457] = [ATBackgroundColor24None]::new()
        $this.ColorMap[458] = [CCAppleRedDark24]::new()
        $this.ColorMap[459] = [CCAppleRedDark24]::new()
        $this.ColorMap[460] = [ATBackgroundColor24None]::new()
        $this.ColorMap[461] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[462] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[463] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[464] = [ATBackgroundColor24None]::new()
        $this.ColorMap[465] = [CCAppleRedDark24]::new()
        $this.ColorMap[466] = [CCAppleRedDark24]::new()
        $this.ColorMap[467] = [ATBackgroundColor24None]::new()
        $this.ColorMap[468] = [ATBackgroundColor24None]::new()
        $this.ColorMap[469] = [ATBackgroundColor24None]::new()
        $this.ColorMap[470] = [ATBackgroundColor24None]::new()
        $this.ColorMap[471] = [ATBackgroundColor24None]::new()
        $this.ColorMap[472] = [ATBackgroundColor24None]::new()
        $this.ColorMap[473] = [ATBackgroundColor24None]::new()
        $this.ColorMap[474] = [ATBackgroundColor24None]::new()
        $this.ColorMap[475] = [ATBackgroundColor24None]::new()
        $this.ColorMap[476] = [ATBackgroundColor24None]::new()
        $this.ColorMap[477] = [ATBackgroundColor24None]::new()
        $this.ColorMap[478] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[479] = [ATBackgroundColor24None]::new()
        $this.ColorMap[480] = [ATBackgroundColor24None]::new() # End Row 12
        $this.ColorMap[481] = [ATBackgroundColor24None]::new()
        $this.ColorMap[482] = [ATBackgroundColor24None]::new()
        $this.ColorMap[483] = [ATBackgroundColor24None]::new()
        $this.ColorMap[484] = [ATBackgroundColor24None]::new()
        $this.ColorMap[485] = [ATBackgroundColor24None]::new()
        $this.ColorMap[486] = [ATBackgroundColor24None]::new()
        $this.ColorMap[487] = [ATBackgroundColor24None]::new()
        $this.ColorMap[488] = [ATBackgroundColor24None]::new()
        $this.ColorMap[489] = [ATBackgroundColor24None]::new()
        $this.ColorMap[490] = [ATBackgroundColor24None]::new()
        $this.ColorMap[491] = [ATBackgroundColor24None]::new()
        $this.ColorMap[492] = [ATBackgroundColor24None]::new()
        $this.ColorMap[493] = [ATBackgroundColor24None]::new()
        $this.ColorMap[494] = [CCAppleRedDark24]::new()
        $this.ColorMap[495] = [ATBackgroundColor24None]::new()
        $this.ColorMap[496] = [ATBackgroundColor24None]::new()
        $this.ColorMap[497] = [ATBackgroundColor24None]::new()
        $this.ColorMap[498] = [ATBackgroundColor24None]::new()
        $this.ColorMap[499] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[500] = [ATBackgroundColor24None]::new()
        $this.ColorMap[501] = [ATBackgroundColor24None]::new()
        $this.ColorMap[502] = [ATBackgroundColor24None]::new()
        $this.ColorMap[503] = [ATBackgroundColor24None]::new()
        $this.ColorMap[504] = [CCAppleRedDark24]::new()
        $this.ColorMap[505] = [ATBackgroundColor24None]::new()
        $this.ColorMap[506] = [ATBackgroundColor24None]::new()
        $this.ColorMap[507] = [ATBackgroundColor24None]::new()
        $this.ColorMap[508] = [ATBackgroundColor24None]::new()
        $this.ColorMap[509] = [ATBackgroundColor24None]::new()
        $this.ColorMap[510] = [ATBackgroundColor24None]::new()
        $this.ColorMap[511] = [ATBackgroundColor24None]::new()
        $this.ColorMap[512] = [ATBackgroundColor24None]::new()
        $this.ColorMap[513] = [ATBackgroundColor24None]::new()
        $this.ColorMap[514] = [ATBackgroundColor24None]::new()
        $this.ColorMap[515] = [ATBackgroundColor24None]::new()
        $this.ColorMap[516] = [ATBackgroundColor24None]::new()
        $this.ColorMap[517] = [ATBackgroundColor24None]::new() # End Row 13
        $this.ColorMap[518] = [ATBackgroundColor24None]::new()
        $this.ColorMap[519] = [ATBackgroundColor24None]::new()
        $this.ColorMap[520] = [ATBackgroundColor24None]::new()
        $this.ColorMap[521] = [ATBackgroundColor24None]::new()
        $this.ColorMap[522] = [ATBackgroundColor24None]::new()
        $this.ColorMap[523] = [ATBackgroundColor24None]::new()
        $this.ColorMap[524] = [ATBackgroundColor24None]::new()
        $this.ColorMap[525] = [ATBackgroundColor24None]::new()
        $this.ColorMap[526] = [ATBackgroundColor24None]::new()
        $this.ColorMap[527] = [ATBackgroundColor24None]::new()
        $this.ColorMap[528] = [ATBackgroundColor24None]::new()
        $this.ColorMap[529] = [ATBackgroundColor24None]::new()
        $this.ColorMap[530] = [ATBackgroundColor24None]::new()
        $this.ColorMap[531] = [ATBackgroundColor24None]::new()
        $this.ColorMap[532] = [ATBackgroundColor24None]::new()
        $this.ColorMap[533] = [ATBackgroundColor24None]::new()
        $this.ColorMap[534] = [ATBackgroundColor24None]::new()
        $this.ColorMap[535] = [ATBackgroundColor24None]::new()
        $this.ColorMap[536] = [ATBackgroundColor24None]::new()
        $this.ColorMap[537] = [ATBackgroundColor24None]::new()
        $this.ColorMap[538] = [ATBackgroundColor24None]::new()
        $this.ColorMap[539] = [ATBackgroundColor24None]::new()
        $this.ColorMap[540] = [ATBackgroundColor24None]::new()
        $this.ColorMap[541] = [ATBackgroundColor24None]::new()
        $this.ColorMap[542] = [ATBackgroundColor24None]::new()
        $this.ColorMap[543] = [ATBackgroundColor24None]::new()
        $this.ColorMap[544] = [ATBackgroundColor24None]::new()
        $this.ColorMap[545] = [ATBackgroundColor24None]::new()
        $this.ColorMap[546] = [ATBackgroundColor24None]::new()
        $this.ColorMap[547] = [ATBackgroundColor24None]::new()
        $this.ColorMap[548] = [ATBackgroundColor24None]::new()
        $this.ColorMap[549] = [ATBackgroundColor24None]::new()
        $this.ColorMap[550] = [ATBackgroundColor24None]::new()
        $this.ColorMap[551] = [ATBackgroundColor24None]::new()
        $this.ColorMap[552] = [ATBackgroundColor24None]::new()
        $this.ColorMap[553] = [ATBackgroundColor24None]::new()
        $this.ColorMap[554] = [ATBackgroundColor24None]::new() # End Row 14

        $this.CreateImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

