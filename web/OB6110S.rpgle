      **********************************************************************                        
      *                                                                                             
      *プログラム  : OB6110S                                                                      
      *              :ＢＰ奨励金推移一覧取得（抽出）                                              
      *               ※OB6111Sから再コピー                                                     
      *                                                                                             
      *作成者      : SSC D.YOSHIDA        2015/06/19                                              
      *                                                                                             
      *変更者      : SSC FURUSHO          2015/09/08                                              
      *変更内容    : ＬＦ変更：Ｌ０４⇒Ｌ０６                                                   
      *              : 月次更新日付⇒処理年月日に変更                                             
      *                                                                                             
      *変更者      : SSC FURUSHO          2017/01/20                                              
      *変更内容    : 東部３部追加対応               A01 D01                                     
      *              : 特殊条件の配賦パターン追加                                                 
      *                                                                                             
      *変更者      : SSC FURUSHO          2017/01/31                                              
      *変更内容    : 東部３部追加対応               A02 D02                                     
      *              : 新潟・静岡配賦パターン変更                                                 
      *                                                                                             
      *変更者      : SSC FURUSHO          2018/03/05                                              
      *変更内容    : 組織変更対応               A03 D03                                         
      *              :                                                                            
      *                                                                                             
      *変更者      : SIT INOUE            2021/07/27                                              
      *変更内容    :型別区分02の判定処理削除  D03                                             
      *                                                                                             
      **********************************************************************                        
      *処理概要    :ＢＰ奨励金推移一覧取得の対象レコードの取得を行う。                          
      **********************************************************************                        
      *ファイル仕様:                                                                              
      *主入力: OB6110L01  UF A TP           ＢＰ物件一覧取得用Ｗ／ＦL01                         
      *主入力: OB6110L02  IF   TP           ＢＰ物件一覧取得用Ｗ／ＦL02                         
      *主入力: OB6110L03  IF   TP           ＢＰ物件一覧取得用Ｗ／ＦL03                         
      *主入力: OB6110B00  IF   TP           ＢＰ物件一覧取得用Ｗ／Ｆ                            
      *主入力: FBTECL06   IF   EC           ＢＰ出荷（明細）ファイルL06                         
      *主入力: FBMEFL02   IF   EF           ＢＰ品目分類マスターL02                             
      *主入力: FBMBSL01   IF   BS           ＢＰ奨励金条件マスタL01                             
      *主入力: FBMBSL02   IF   BS           ＢＰ奨励金条件マスタL02                             
      *主入力: FBMBTL01   IF   BT           ＢＰ奨励金条件明細マスタL01                         
      *主入力: FBMBTL02   IF   BT           ＢＰ奨励金条件明細マスタL02                         
      *主入力: FBMBTL03   IF   BT           ＢＰ奨励金条件明細マスタL03                         
      *主入力: FSSPEL01   IF   PE           ＳＡＰ　ＬＦ：組織単位営業所テキストL01             
      *主入力: FSSPCL01   IF   PC           ＳＡＰ　ＬＦ：品目テキストL01                       
      *主入力: FBMEEL01   IF   EE           ＢＰ部署マスターL01                                 
      *主入力: FBMEHL01   IF   EH           ＢＰ特施工マスターL01                               
      *主入力: FBMEIL01   IF   EI           ＢＰ県コードマスターL01                             
      *                                                                                             
      **********************************************************************                        
      *使用標識    : 89:ON      エラー判定                                                      
      *                                                                                             
      **********************************************************************                        
      *リターンコード／結果コード                                                                 
      *              : 00 00      正常終了                                                        
      *              : 00 11      該当データなし                                                  
      *              : 00 12      該当データ６５０００件以上                                      
      *                                                                                             
      **********************************************************************                        
      *パラメータ  :                                                                              
      *<<INPUT PARM>>                                                                               
      *  2:WISYORKB    1     A  I  処理区分                                                       
      *  3:WIMODEKB    2     A  I  モード区分                                                     
      *  4:WISEIGKB    2     A  I  制御区分                                                       
      *～１０までバッファ                                                                         
      *<<見出項目>>                                                                               
      * 11:WIBSTPKB    2     A  I  奨励金タイプ                                                   
      * 12:WIFRMNDT    6   0 S  I  適用月度FROM　                                               
      * 13:WIBSSHKB    2     A  I  奨励金集約区分                                                 
      *                                                                                             
      *<<OUTPUT PARM>>                                                                              
      *<<共通部パラメータ>>                                                                       
      *  1:WORTRNCD     2    A  O  リターンコード                                                 
      *  2:WOKEKACD     2    A  O  結果コード                                                     
      *  3:WOKENSU      5  0 S  O  取得件数                                                       
      *  4:WOKEIZFG     1    A  O  継続区分                                                       
      *  5:WOSOKEN      5  0 S  O  総取得件数                                                     
      *<<固有部パラメータ>>                                                                       
      *<<見出項目>>                                                                               
      *  6:WOBSSHKB     2    A  O  奨励金集約区分                                                 
      *                                                                                             
      **********************************************************************                        
     H DATEDIT(*YMD/)                                                                               
     F**********************************************************************                        
     F*ファイル                                                                                   
     F**********************************************************************                        
     F*ＢＰ物件一覧取得用Ｗ／ＦL01                                                                
     FOB6110L01 UF A E           K DISK    PREFIX(TP)                                               
     F                                     RENAME(OB6110R:OB6110R01)                                
     F*ＢＰ物件一覧取得用Ｗ／ＦL02                                                                
     FOB6110L02 IF   E           K DISK    PREFIX(TP)                                               
     F                                     RENAME(OB6110R:OB6110R02)                                
     F*ＢＰ物件一覧取得用Ｗ／ＦL05                                                                
     FOB6110L03 IF A E           K DISK    PREFIX(TP)                                               
     F                                     RENAME(OB6110R:OB6110R03)                                
     F*ＢＰ物件一覧取得用Ｗ／Ｆ                                                                   
     FOB6110B00 IF   E           K DISK    PREFIX(TP)                                               
     F                                     RENAME(OB6110R:OB6110R00)                                
     F*ＢＰ出荷（明細）ファイルL04                                                                
     FFBTECL06  IF   E           K DISK    PREFIX(EC)                                               
     F*ＢＰ品目分類マスターL02                                                                    
     FFBMEFL02  IF   E           K DISK    PREFIX(EF)                                               
     F*ＢＰ奨励金条件マスタL01                                                                    
     FFBMBSL01  IF   E           K DISK    PREFIX(BS)                                               
     F                                     RENAME(FBMBSR:FBMBSR01)                                  
     F*ＢＰ奨励金条件マスタL02                                                                    
     FFBMBSL02  IF   E           K DISK    PREFIX(BS)                                               
     F                                     RENAME(FBMBSR:FBMBSR02)                                  
     F*ＢＰ奨励金条件明細マスタL01                                                                
     FFBMBTL01  IF   E           K DISK    PREFIX(BT)                                               
     F                                     RENAME(FBMBTR:FBMBTR01)                                  
     F*ＢＰ奨励金条件明細マスタL02                                                                
     FFBMBTL02  IF   E           K DISK    PREFIX(BT)                                               
     F                                     RENAME(FBMBTR:FBMBTR02)                                  
     F*ＢＰ奨励金条件明細マスタL03                                                                
     FFBMBTL03  IF   E           K DISK    PREFIX(BT)                                               
     F                                     RENAME(FBMBTR:FBMBTR03)                                  
     F*ＳＡＰ　ＬＦ：組織単位営業所テキストL01                                                    
     FFSSPEL01  IF   E           K DISK    PREFIX(PE)                                               
     F*ＳＡＰ　ＬＦ：品目テキストL01                                                              
     FFSSPCL01  IF   E           K DISK    PREFIX(PC)                                               
     F*ＢＰ部署マスターL01                                                                        
     FFBMEEL01  IF   E           K DISK    PREFIX(EE)                                               
     F*ＢＰ特施工マスターL01                                                                      
     FFBMEHL01  IF   E           K DISK    PREFIX(EH)                                               
     F*ＢＰ県コードマスターL01                                                                    
     FFBMEIL01  IF   E           K DISK    PREFIX(EI)                                               
     F*                                                                                             
     D**********************************************************************                        
     D*ファイルデータ構造（ＥＤＳ）                                                               
     D**********************************************************************                        
     D**********************************************************************                        
     D*アドレス定義                                                                               
     D**********************************************************************                        
     D**********************************************************************                        
     D*コンスタントフィールド                                                                     
     D**********************************************************************                        
     D*明細送信最大数                                                                             
YS2  D WCMAXD          C                   CONST(1000)                                              
     D*対象月数                                                                                   
YS2  D WCDTM           C                   CONST(12)                                                
     D*                                                                                             
     D**********************************************************************                        
     D*配列／テーブル                                                                             
     D**********************************************************************                        
     D**********************************************************************                        
     D*指標                                                                                       
     D**********************************************************************                        
     D  IX1            S              5  0 INZ                                                      
     D  IX2            S              5  0 INZ                                                      
     D  IX3            S              5  0 INZ                                                      
     D  IX4            S              5  0 INZ                                                      
     D  IX5            S              5  0 INZ                                                      
     D  IX6            S              5  0 INZ                                                      
     D  IX7            S              5  0 INZ                                                      
     D  IX8            S              5  0 INZ                                                      
     D  IX9            S              5  0 INZ                                                      
     D  IXA            S              5  0 INZ                                                      
     D  IXB            S              5  0 INZ                                                      
     D  IXC            S              5  0 INZ                                                      
     D  IXD            S              5  0 INZ                                                      
     D  IXE            S              5  0 INZ                                                      
     D*                                                                                             
     D**********************************************************************                        
     D*データ構造（ＤＳ）                                                                         
     D**********************************************************************                        
     D*プログラム状況データ構造                                                                   
     D                SDS                                                                           
     D @@PGNM                  1     10                                                             
     D @@PSTS                 11     15  0                                                          
     D @@SCST                 21     28                                                             
     D @@WSID                244    253                                                             
     D*                                                                                             
     D                 DS                                                                           
     D ECSYORDT                       8  0                                      月次更新日付      
     D WXGTKSYM                1      6  0                                      月次更新年月      
     D*                                                                                             
     D**********************************************************************                        
     D*エントリーパラメータ定義                                                                   
     D**********************************************************************                        
      *入力パラメータ                                                                             
      *<<INPUT PARM>>                                                                               
     D WIPARM          DS                                                                           
     D  WISYORKB                      1                                         処理区分          
     D  WIMODEKB                      2                                         モード区分        
     D  WISEIGKB                      2                                         制御区分          
      *<<見出項目>>                                                                               
     D  WIBSTPKB                      2                                         奨励金タイプ      
     D  WIFRMNDT                      6  0                                      適用月度FROM　  
     D  WIBSSHKB                      2                                         奨励金集約区分    
      *                                                                                             
      *<<OUTPUT PARM>>                                                                              
     D WOPARM          DS                                                                           
     D  WORTRNCD                      2                                         リターンコード    
     D  WOKEKACD                      2                                         結果コード        
     D  WOKENSU                       5  0                                      取得件数          
     D  WOKEIZFG                      1                                         継続フラグ        
     D  WOSOKEN                       5  0                                      総取得件数        
      *                                                                                             
      *<<見出項目>>                                                                               
     D  WOBSSHKB                      2                                         奨励金集約区分    
     D*                                                                                             
      *漢字項目検索サブルーチンパラメータ=================================                        
     D WIPARM0100      DS                                                                           
     D  W3NAME01                    400                                         漢字項目１        
     D  W3NAME02                    400                                         漢字項目２        
      *                                                                                             
     D WOPARM0100      DS                                                                           
     D  W31BOOL                       1                                                             
     D*                                                                                             
     D*=====================================================================                        
     D*                                                                                             
     D**********************************************************************                        
     D*ＬＤＡ項目                                                                                 
     D**********************************************************************                        
     D/COPY DSLDA                                                                                   
     D*                                                                                             
     D**********************************************************************                        
     D*ワークフィールド                                                                           
     D**********************************************************************                        
     D*総レコード件数                                                                             
     D WSSOKEN         S              5  0                                                          
     D*                                                                                             
     D*レコード件数                                                                               
     D WXKENSU         S              5  0 INZ                                                      
     D*                                                                                             
     D*日付計算用                                                                                 
     D                 DS                                                                           
     D  WXDATE                 1      8  0                                                          
     D  WXCCYY                 1      4  0                                      年月              
     D  WXMM                   5      6  0                                      年月              
     D  WXDD                   7      8  0                                      年月              
     D  WXCYM                  1      6  0                                      年月              
     D  WXYMD                  3      8  0                                      年月日            
     D  WXDATED        S               D                                                            
     D*                                                                                             
     D                 DS                                                                           
     D  WXDATE2                1      8  0                                                          
     D  WXCYM2                 1      6  0                                      年月              
     D*                                                                                             
     D*営業部                                                                                     
     D WXEGBUCD        S              4    DIM(9999) INZ                        営業部            
     D WXEGBUNM        S             42    DIM(9999) INZ                        営業部名称        
     D WXEGBUSR        S              5S 0 INZ                                  営業部数量        
     D*                                                                                             
     D*汎用コード                                                                                 
     D WXBSGECD        S             20    DIM(9999) INZ                        汎用コード        
     D WXBSGENM        S             42    DIM(9999) INZ                        汎用名称          
     D WXBSGESR        S              5S 0 INZ                                  汎用数量          
     D*                                                                                             
     D*型関連                                                                                     
     D WXKABTKB        S              2    DIM(99) INZ                          型別区分          
     D WXKABTNM        S             22    DIM(99) INZ                          型別名            
     D WXKABTSR        S              5S 0 INZ                                  型別区分数量      
     D*                                                                                             
     D WXSTATDT        S              8  0 INZ                                  開始日            
     D WXENDDT         S              8  0 INZ                                  終了日            
     D*                                                                                             
     D WXBSGEC2        S             20    INZ                                  汎用コード        
     D WXBSGEN2        S             42    INZ                                  汎用名称          
     D WXEGBUC2        S              4    INZ                                  営業部コード      
     D WXEGBUN2        S             42    INZ                                  営業部名称        
     D*                                                                                             
     D WXGTKSYMB       S              6  0 INZ                                  月次更新年月BK    
     D WXEGBUCDB       S              4    INZ                                  営業部BK          
     D*                                                                                             
     D WXGTKSYMBF      S              6  0 INZ                                  月次更新年月BF    
     D WXKISOKBBF      S              2    INZ                                  階層区分　　BF    
     D WXEGBUCDBF      S              4    INZ                                  営業部      BF    
     D WXEGBUNMBF      S             42    INZ                                  営業部名称  BF    
     D WXBSGECDBF      S             20    INZ                                  汎用コード  BF    
     D WXBSGENMBF      S             42    INZ                                  汎用名称　　BF    
     D WXKABTKBBF      S              2    INZ                                  型別区分    BF    
     D WXKABTNMBF      S             22    INZ                                  型別名      BF    
     D WXBPSKKGBF      S             15  2 INZ                                  ＢＰ仕切金額BF    
     D WXBPURKGBF      S             15  2 INZ                                  ＢＰ売上金額BF    
     D WXBSKARTBF      S              5  3 INZ                                  奨励金掛率  BF    
     D WXBPSRKGBF      S             15  2 INZ                                  奨励金金額  BF    
     D WXBPSKKMBF      S             15  2 INZ                                  ＢＰ仕切金元BF    
     D WXBPURKMBF      S             15  2 INZ                                  ＢＰ売上金元BF    
     D WXBPSRKMBF      S             15  2 INZ                                  奨励金金元  BF    
     D WXBSTNKBBF      S              2    INZ                                  算出単位    BF    
     D WXBSMRKBBF      S              2    INZ                                  丸め区分    BF    
     D WXBSMTKBBF      S              2    INZ                                  丸め単位    BF    
     D*                                                                                             
     D*丸め処理関連                                                                               
     D WXBSMRSR        S             30 10 INZ                                  丸め数量          
     D WXMTKBSR        S             10  0 INZ                                  丸め単位数量      
     D*                                                                                             
     D WXSP20FG        S              1    INZ                                  特殊条件区分２０FG
     D WXSP20RT        S              5  4 INZ                                  特殊条件区分２０率
     D WXSP20AM1       S             15  2 INZ                                  一部東京合計      
     D WXSP20AM2       S             15  2 INZ                                  東京合計          
     D WXSP20A1        S             15  2 INZ                                  一部東京合計旭    
     D WXSP20A2        S             15  2 INZ                                  東京合計旭　      
     D WXSP20GENM      S             42    INZ                                  汎用名称          
 A01 D*                                                                                             
 A01 D WXSP21FG        S              1    INZ                                  特殊条件区分２０FG
 A01 D WXSP21RT1       S              5  4 INZ                                  特殊条件区分２０率
 A01 D WXSP21RT2       S              5  4 INZ                                  特殊条件区分２０率
 A01 D WXSP21RT3       S              5  4 INZ                                  特殊条件区分２０率
 A01 D WXSP21AMT       S             15  2 INZ                                  一部東京合計      
 A01 D WXSP21AM1       S             15  2 INZ                                  一部東京合計      
 A01 D WXSP21AM2       S             15  2 INZ                                  東京合計          
 A01 D WXSP21AM3       S             15  2 INZ                                  東京合計          
 A01 D WXSP21AT        S             15  2 INZ                                  一部東京合計旭    
 A01 D WXSP21AT1       S             15  2 INZ                                  一部東京合計旭    
 A01 D WXSP21AT2       S             15  2 INZ                                  東京合計旭　      
 A01 D WXSP21GENM      S             42    INZ                                  汎用名称          
     D*                                                                                             
     D WXSP30FG        S              1    INZ                                  特殊条件区分３０FG
     D WXSP30RT        S              5  4 INZ                                  特殊条件区分３０率
     D WXSP30AM1       S             15  2 INZ                                  新潟合計          
     D WXSP30AM2       S             15  2 INZ                                  新潟静岡合計      
     D WXSP30A1        S             15  2 INZ                                  ３０東京合計      
     D WXSP30A2        S             15  2 INZ                                  ３０東京合計      
     D WXSP30GENM      S             42    INZ                                  汎用名称          
     D*                                                                                             
     C**********************************************************************                        
     C*キーフィールド定義                                                                         
     C**********************************************************************                        
     C*ＢＰ奨励金推移一覧Ｗ／ＦL01                                                                
     C     *LIKE         DEFINE    TPEGBUCD      WKEGBUCD                       営業部            
     C     *LIKE         DEFINE    TPBSGECD      WKBSGECD                       汎用コード        
     C     *LIKE         DEFINE    TPKABTKB      WKKABTKB                       型別区分          
     C     *LIKE         DEFINE    TPGTKSYM      WKGTKSYM                       月次更新年月      
     C     *LIKE         DEFINE    TPKISOKB      WKKISOKB                       階層区分　　      
     C*ＢＰ出荷（明細）ファイルL04                                                                
     C     *LIKE         DEFINE    ECCLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    ECSYORDT      WKSYORDT                       月次更新日付      
     C*ＢＰ品目分類マスターL02                                                                    
     C     *LIKE         DEFINE    EFCLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    EFKABTKB      WKKABTKB                       型別区分          
     C*ＢＰ奨励金条件マスタL01                                                                    
     C     *LIKE         DEFINE    BSCLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C     *LIKE         DEFINE    BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C*ＢＰ奨励金条件マスタL02                                                                    
     C     *LIKE         DEFINE    BSCLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C     *LIKE         DEFINE    BSBSSHKB      WKBSSHKB                       奨励金集約区分    
     C     *LIKE         DEFINE    BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C*ＢＰ奨励金条件明細マスタL01                                                                
     C     *LIKE         DEFINE    BTCLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    BTBSTPKB      WKBSTPKB                       奨励金タイプ      
     C     *LIKE         DEFINE    BTFRMNDT      WKFRMNDT                       適用月度FROM      
     C     *LIKE         DEFINE    BTBSJKKB      WKBSJKKB                       奨励金条件区分    
     C*ＢＰ奨励金条件明細マスタL02                                                                
     C     *LIKE         DEFINE    BTCLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    BTBSTPKB      WKBSTPKB                       奨励金タイプ      
     C     *LIKE         DEFINE    BTFRMNDT      WKFRMNDT                       適用月度FROM      
     C     *LIKE         DEFINE    BTBSJKKB      WKBSJKKB                       奨励金条件区分    
     C     *LIKE         DEFINE    BTKKRHKB      WKKKRHKB                       型別　：掛率　    
     C*ＢＰ奨励金条件明細マスタL03                                                                
     C     *LIKE         DEFINE    BTCLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    BTBSTPKB      WKBSTPKB                       奨励金タイプ      
     C     *LIKE         DEFINE    BTFRMNDT      WKFRMNDT                       適用月度FROM      
     C     *LIKE         DEFINE    BTBSJKKB      WKBSJKKB                       奨励金条件区分    
     C     *LIKE         DEFINE    BTBSSPKB      WKBSSPKB                       奨励金特殊条件区分
     C*ＳＡＰ　ＬＦ：組織単位営業所テキストL01                                                    
     C     *LIKE         DEFINE    PEMANDT       WKMANDT                        クライアント      
     C     *LIKE         DEFINE    PESPRAS       WKSPRAS                        言語キー          
     C     *LIKE         DEFINE    PEVKBUR       WKVKBUR                        営業所            
     C*ＳＡＰ　ＬＦ：品目テキストL01                                                              
     C     *LIKE         DEFINE    PCMANDT       WKMANDT                        クライアント      
     C     *LIKE         DEFINE    PCMATNR       WKMATNR                        品目コード        
     C     *LIKE         DEFINE    PCSPRAS       WKSPRAS                        言語キー          
     C*ＢＰ部署マスターL01                                                                        
     C     *LIKE         DEFINE    EECLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    EEOBSYCD      WKOBSYCD                       旧部署コード      
     C     *LIKE         DEFINE    EEOKYKCD      WKOKYKCD                       旧客先コード      
     C*                                                                                             
     C*ＢＰ特施工マスターL01                                                                      
     C     *LIKE         DEFINE    EHCLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    EHTKYKCD      WKTKYKCD                       特施工コード      
     C*                                                                                             
     C*ＢＰ県コードマスターL01                                                                    
     C     *LIKE         DEFINE    EICLNTNO      WKCLNTNO                       クライアント      
     C     *LIKE         DEFINE    EIFUKNCD      WKFUKNCD                       府県コード        
     C*                                                                                             
     C**********************************************************************                        
     C*キー・リスト                                                                               
     C**********************************************************************                        
     C*ＢＰ奨励金推移一覧Ｗ／ＦB00                                                                
     C     WKKEYTP0      KLIST                                                                      
     C                   KFLD                    WKKISOKB                       階層区分　　      
     C*                                                                                             
     C*ＢＰ奨励金推移一覧Ｗ／ＦL01                                                                
     C     WKKEYTP1      KLIST                                                                      
     C                   KFLD                    WKGTKSYM                       月次更新年月      
     C                   KFLD                    WKEGBUCD                       営業部            
     C                   KFLD                    WKBSGECD                       汎用コード        
     C                   KFLD                    WKKABTKB                       型別区分          
     C                   KFLD                    WKKISOKB                       階層区分　　      
     C*                                                                                             
     C     WKKEYTP12     KLIST                                                                      
     C                   KFLD                    WKGTKSYM                       月次更新年月      
     C*                                                                                             
     C*ＢＰ奨励金推移一覧Ｗ／ＦL02                                                                
     C     WKKEYTP2      KLIST                                                                      
     C                   KFLD                    WKBSGECD                       汎用コード        
     C                   KFLD                    WKEGBUCD                       営業部            
     C*                                                                                             
     C*ＢＰ奨励金推移一覧Ｗ／ＦL03                                                                
     C     WKKEYTP3      KLIST                                                                      
     C                   KFLD                    WKKABTKB                       型別区分          
     C*                                                                                             
     C*ＢＰ出荷（明細）ファイルL04                                                                
     C     WKKEYEC       KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKSYORDT                       月次更新日付      
     C*                                                                                             
     C*ＢＰ品目分類マスターL02                                                                    
     C     WKKEYEF       KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKKABTKB                       型別区分          
     C*                                                                                             
     C*ＢＰ奨励金条件マスタL01                                                                    
     C     WKKEYBS1      KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKBSTPKB                       奨励金タイプ      
     C                   KFLD                    WKBSSHKB                       奨励金集約区分    
     C                   KFLD                    WKFRMNDT                       適用月度FROM      
     C     WKKEYBS2      KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKBSTPKB                       奨励金タイプ      
     C                   KFLD                    WKBSSHKB                       奨励金集約区分    
     C*                                                                                             
     C*ＢＰ奨励金条件明細マスタL01                                                                
     C     WKKEYBT1      KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKBSTPKB                       奨励金タイプ      
     C                   KFLD                    WKFRMNDT                       適用月度FROM      
     C                   KFLD                    WKBSJKKB                       奨励金条件区分    
     C*                                                                                             
     C*ＢＰ奨励金条件明細マスタL02                                                                
     C     WKKEYBT2      KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKBSTPKB                       奨励金タイプ      
     C                   KFLD                    WKFRMNDT                       適用月度FROM      
     C                   KFLD                    WKBSJKKB                       奨励金条件区分    
     C                   KFLD                    WKKKRHKB                       型別　：掛率　    
     C*                                                                                             
     C*ＢＰ奨励金条件明細マスタL02                                                                
     C     WKKEYBT3      KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKBSTPKB                       奨励金タイプ      
     C                   KFLD                    WKFRMNDT                       適用月度FROM      
     C                   KFLD                    WKBSJKKB                       奨励金条件区分    
     C                   KFLD                    WKBSSPKB                       奨励金特殊条件区分
     C*                                                                                             
     C*ＳＡＰ　ＬＦ：組織単位営業所テキストL01                                                    
     C     WKKEYPE       KLIST                                                                      
     C                   KFLD                    WKMANDT                        クライアント      
     C                   KFLD                    WKSPRAS                        言語キー          
     C                   KFLD                    WKVKBUR                        営業所            
     C*                                                                                             
     C*ＳＡＰ　ＬＦ：品目テキストL01                                                              
     C     WKKEYPC       KLIST                                                                      
     C                   KFLD                    WKMANDT                        クライアント      
     C                   KFLD                    WKMATNR                        品目コード        
     C                   KFLD                    WKSPRAS                        言語キー          
     C*                                                                                             
     C*ＢＰ部署マスターL01                                                                        
     C     WKKEYEE       KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKOBSYCD                       旧部署コード      
     C                   KFLD                    WKOKYKCD                       旧客先コード      
     C*                                                                                             
     C*ＢＰ特施工マスターL01                                                                      
     C     WKKEYEH       KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKTKYKCD                       特施工コード      
     C*                                                                                             
     C*ＢＰ県コードマスターL01                                                                    
     C     WKKEYEI       KLIST                                                                      
     C                   KFLD                    WKCLNTNO                       クライアント      
     C                   KFLD                    WKFUKNCD                       府県コード        
     C*                                                                                             
     C**********************************************************************                        
     C*パラメータ・リスト                                                                         
     C**********************************************************************                        
     C*入力パラメータ                                                                             
     C     *ENTRY        PLIST                                                                      
     C                   PARM                    WIPARM                                             
     C                   PARM                    WOPARM                                             
     C*                                                                                             
     C**********************************************************************                        
     C*                                                                                             
     C**********************************************************************                        
      *初期処理                                                                                   
     C                   EXSR      #FIRST                                                           
      *入力パラメータチェック                                                                     
     C                   EXSR      #CHKPRM                                                          
      *メイン処理                                                                                 
     C  N89              EXSR      #MAIN                                                            
      *応答パラメータチェック                                                                     
     C  N89              EXSR      #CHKOPRM                                                         
      *終了処理                                                                                   
     C                   EXSR      #END                                                             
      *                                                                                             
     C**********************************************************************                        
     C***初期処理                                                      ***                        
     C**********************************************************************                        
     C     #FIRST        BEGSR                                                                      
      *                                                                                             
     C                   SETOFF                                       8990                          
     C                   SETOFF                                       11                            
      *                                                                                             
      *ローカルデータエリア取得                                                                   
     C     *DTAARA       DEFINE    *LDA          DSLDA                                              
     C                   IN        DSLDA                                                            
      *                                                                                             
      *ワークフィールドのクリア                                                                   
     C                   Z-ADD     *ZERO         WXKENSU                                            
      *                                                                                             
      *パラメータ初期設定                                                                         
     C                   CLEAR                   WOPARM                                             
     C                   MOVEL(P)  '00'          WORTRNCD                                           
     C                   MOVEL(P)  '00'          WOKEKACD                                           
     C                   Z-ADD     *ZERO         WOKENSU                                            
     C                   MOVEL(P)  '0'           WOKEIZFG                                           
     C                   Z-ADD     *ZERO         WOSOKEN                                            
      *                                                                                             
     C*初期アドレスセット                                                                         
     C                   IF        WISYORKB <> '1'                                                  
     C                   Z-ADD     WSSOKEN       WOSOKEN                                            
     C                   ENDIF                                                                      
     C*                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*入力パラメータチェック                                                                     
     C**********************************************************************                        
     C     #CHKPRM       BEGSR                                                                      
      *                                                                                             
      *奨励金集約区分---------------------------                                                  
     C                   SETOFF                                       505152                        
     C                   SETOFF                                       53                            
      *部署別                                                                                     
     C                   IF        (WIBSSHKB = '10')                            IF1                 
     C                   SETON                                        50                            
      *客先別                                                                                     
     C                   ELSEIF    (WIBSSHKB = '20')                            ELSE-IF1            
     C                   SETON                                        51                            
      *特施工別                                                                                   
     C                   ELSEIF    (WIBSSHKB = '30')                            ELSE-IF1            
     C                   SETON                                        52                            
      *都道府県別                                                                                 
     C                   ELSEIF    (WIBSSHKB = '40')                            ELSE-IF1            
     C                   SETON                                        53                            
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *対象日付の取得---------------------------                                                  
      *開始日-------------------------                                                            
     C                   Z-ADD     WIFRMNDT      WXCYM                          適用月度FROM      
     C                   Z-ADD     1             WXDD                           日                
     C                   Z-ADD     WXDATE        WXSTATDT                       開始日            
      *                                                                                             
      *終了日（開始日から一年）-------                                                            
     C                   Z-ADD     WIFRMNDT      WXCYM                          適用月度FROM      
     C                   Z-ADD     1             WXDD                           日                
     C                   MOVE      WXDATE        WXDATED                                            
     C                   ADDDUR    WCDTM:*M      WXDATED                                            
     C                   MOVE      WXDATED       WXENDDT                        終了日            
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*特殊条件区分２０関連処理                                                                   
     C**********************************************************************                        
     C     #SPKB20       BEGSR                                                                      
      *                                                                                             
      *初期化処理-------------------------------                                                  
     C                   Z-ADD     WIFRMNDT      WXCYM                          適用月度FROM      
     C                   Z-ADD     1             WXDD                           日                
      *                                                                                             
      *===========================================                                                  
     C     1             DO        WCDTM         IX8                            DO1                 
      *                                                                                             
      *初期化処理---------------------                                                            
     C                   MOVEL(P)  *BLANK        WXSP20FG                       特殊条件区分２０FG
     C                   Z-ADD     *ZERO         WXSP20AM1                      一部東京合計      
     C                   Z-ADD     *ZERO         WXSP20AM2                      東京合計          
 A01 C                   Z-ADD     *ZERO         WXSP21AMT                      東京合計          
 A01 C                   Z-ADD     *ZERO         WXSP21AM1                      東京合計          
 A01 C                   Z-ADD     *ZERO         WXSP21AM2                      東京合計          
 A01 C                   Z-ADD     *ZERO         WXSP21AM3                      東京合計          
     C                   MOVEL(P)  *BLANK        WXSP30FG                       特殊条件区分３０FG
     C                   Z-ADD     *ZERO         WXSP30AM1                      新潟合計          
     C                   Z-ADD     *ZERO         WXSP30AM2                      新潟静岡合計      
      *                                                                                             
      *日付加算-----------------------                                                            
     C                   IF        (IX8 <> 1)                                   IF1                 
     C                   MOVE      WXDATE        WXDATED                                            
     C                   ADDDUR    1:*M          WXDATED                                            
     C                   MOVE      WXDATED       WXDATE                                             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *ＢＰ奨励金条件マスタ情報取得---                                                            
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
     C                   Z-ADD     WXCYM         WKFRMNDT                       適用月度FROM      
     C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
     C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
     C   80              ITER                                                   ITER-DO1            
      *                                                                                             
      *特殊条件対象チェック-----------                                                            
      *東京特殊処理: 20                                                                           
     C                   MOVEL(P)  BSCLNTNO      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '50'          WKBSJKKB                       奨励金条件区分    
     C                   MOVEL(P)  '20'          WKBSSPKB                       奨励金特殊条件区分
     C     WKKEYBT3      CHAIN     FBMBTL03                           80        奨励金条件明細    
     C  N80              MOVEL(P)  '1'           WXSP20FG                       特殊条件区分２０FG
 A01  *                                                                                             
 A01  *東京特殊処理: 21                                                                           
 A01 C                   MOVEL(P)  BSCLNTNO      WKCLNTNO                       クライアント      
 A01 C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
 A01 C                   MOVEL(P)  BSFRMNDT      WKFRMNDT                       適用月度FROM      
 A01 C                   MOVEL(P)  '50'          WKBSJKKB                       奨励金条件区分    
 A01 C                   MOVEL(P)  '21'          WKBSSPKB                       奨励金特殊条件区分
 A01 C     WKKEYBT3      CHAIN     FBMBTL03                           80        奨励金条件明細    
 A01 C  N80              MOVEL(P)  '1'           WXSP21FG                       特殊条件区分２１FG
      *                                                                                             
      *新潟＋静岡特殊処理：30                                                                     
     C                   MOVEL(P)  '30'          WKBSSPKB                       奨励金特殊条件区分
     C     WKKEYBT3      CHAIN     FBMBTL03                           80        奨励金条件明細    
     C  N80              MOVEL(P)  '1'           WXSP30FG                       特殊条件区分３０FG
      *                                                                                             
     C                   IF        (WXSP20FG = *BLANK) AND                      IF1                 
 A01 C                             (WXSP21FG = *BLANK) AND                      IF1                 
     C                             (WXSP30FG = *BLANK)                                              
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *特殊条件区分２０---------------                                                            
     C                   IF        (WXSP20FG  <> *BLANK)                        IF1                 
      *                                                                                             
      *ＢＰ出荷（明細）読み込み--                                                                 
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   Z-ADD     WXDATE        WKSYORDT                       月次更新日付      
     C     WKKEYEC       SETLL     FBTECL06                                     ＢＰ出荷（明細）  
      *============================                                                                 
     C                   DO        *HIVAL                                       DO2                 
     C                   READ      FBTECL06                               90    ＢＰ出荷（明細）  
     C   90              LEAVE                                                  LEAVE-DO2           
      *                                                                                             
     C                   Z-ADD     ECSYORDT      WXDATE2                        月次更新日付      
     C                   IF        (WXCYM < WXCYM2)                             IF1                 
     C                   LEAVE                                                  LEAVE-DO2           
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *ＢＰ部署マスター情報取得                                                                   
     C                   MOVEL(P)  ECCLNTNO      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  ECOBSYCD      WKOBSYCD                       旧部署コード      
     C                   MOVEL(P)  ECOKYKCD      WKOKYKCD                       旧客先コード      
     C     WKKEYEE       CHAIN     FBMEEL01                           80        部署マスター      
     C   80              ITER                                                   ITER-DO2            
      *                                                                                             
      *特殊条件２０合計                                                                           
     C                   IF        (EESYOKCD = 'B')                             IF1                 
     C                   ADD       ECBPURKG      WXSP20AM1                      一部東京合計      
     C                   ADD       ECBPURKG      WXSP20AM2                      東京合計          
     C                   ELSEIF    (EESYOKCD = 'A')                             ELSE-IF1            
     C                   ADD       ECBPURKG      WXSP20AM2                      東京合計          
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
     C                   ENDDO                                                  END-DO2             
      *============================                                                                 
      *                                                                                             
     C                   IF        (WXSP20AM2 <> *ZERO)                         IF1                 
     C                   EVAL      WXSP20RT = %INTH(WXSP20AM1 / WXSP20AM2 *100) 特殊条件区分２０率
     C                                        / 100                                                 
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *============================                                                                 
     C     1             DO        WXKABTSR      IX9                            DO2                 
      *                                                                                             
      *初期化処理-----------                                                                      
     C                   Z-ADD     *ZERO         WXSP20A1                       一部東京合計旭    
     C                   Z-ADD     *ZERO         WXSP20A2                       東京合計旭        
     C                   MOVEL(P)  *BLANK        WXSP20GENM                     汎用名称          
      *                                                                                             
      *東部営業一部、二部の東京の売上金額を足す                                                   
      *東部営業一部                                                                               
     C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
     C                   MOVEL(P)  'A251'        WKEGBUCD                       営業部            
     C                   MOVEL(P)  '01110103'    WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKB(IX9) WKKABTKB                       型別区分          
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP1      CHAIN(N)  OB6110L01                          80        ワークファイル    
     C  N80              ADD       TPBPURKM      WXSP20A2                       東京合計旭        
     C  N80              MOVEL(P)  TPBSGENM      WXSP20GENM                     汎用名称          
      *                                                                                             
      *東部営業二部                                                                               
 D03 C***                MOVEL(P)  'A252'        WKEGBUCD                       営業部            
 A03 C***                MOVEL(P)  'A257'        WKEGBUCD                       営業部            
 A03 C                   MOVEL(P)  'A252'        WKEGBUCD                       営業部            
     C     WKKEYTP1      CHAIN(N)  OB6110L01                          80        ワークファイル    
     C  N80              ADD       TPBPURKM      WXSP20A2                       東京合計旭        
     C  N80              MOVEL(P)  TPBSGENM      WXSP20GENM                     汎用名称          
      *                                                                                             
      *東部営業一部更新-----                                                                      
     C                   EXSR      #WRTSP20A251                                                     
      *                                                                                             
      *東部営業二部更新-----                                                                      
     C                   EXSR      #WRTSP20A252                                                     
      *                                                                                             
     C                   ENDDO                                                  END-DO2             
      *============================                                                                 
      *                                                                                             
     C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01  *特殊条件区分２１---------------                                                            
 A01 C                   IF        (WXSP21FG  <> *BLANK)                        IF1                 
 A01  *                                                                                             
 A01  *ＢＰ出荷（明細）読み込み--                                                                 
 A01 C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
 A01 C                   Z-ADD     WXDATE        WKSYORDT                       月次更新日付      
 A01 C     WKKEYEC       SETLL     FBTECL06                                     ＢＰ出荷（明細）  
 A01  *============================                                                                 
 A01 C                   DO        *HIVAL                                       DO2                 
 A01 C                   READ      FBTECL06                               90    ＢＰ出荷（明細）  
 A01 C   90              LEAVE                                                  LEAVE-DO2           
 A01  *                                                                                             
 A01 C                   Z-ADD     ECSYORDT      WXDATE2                        月次更新日付      
 A01 C                   IF        (WXCYM < WXCYM2)                             IF1                 
 A01 C                   LEAVE                                                  LEAVE-DO2           
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01  *ＢＰ部署マスター情報取得                                                                   
 A01 C                   MOVEL(P)  ECCLNTNO      WKCLNTNO                       クライアント      
 A01 C                   MOVEL(P)  ECOBSYCD      WKOBSYCD                       旧部署コード      
 A01 C                   MOVEL(P)  ECOKYKCD      WKOKYKCD                       旧客先コード      
 A01 C     WKKEYEE       CHAIN     FBMEEL01                           80        部署マスター      
 A01 C   80              ITER                                                   ITER-DO2            
 A01  *                                                                                             
 A01  *特殊条件２１合計                                                                           
 A01 C                   IF        (EESYOKCD = 'B')                             IF1                 
 A01 C                   ADD       ECBPURKG      WXSP21AM1                      一部東京合計      
 A01 C                   ADD       ECBPURKG      WXSP21AMT                      東京合計          
 A01 C                   ELSEIF    (EESYOKCD = 'A')                             ELSE-IF1            
 A01 C                   ADD       ECBPURKG      WXSP21AM2                      二部東京合計      
 A01 C                   ADD       ECBPURKG      WXSP21AMT                      東京合計          
 A01 C                   ELSEIF    (EESYOKCD = 'E')                             ELSE-IF1            
 A01 C                   ADD       ECBPURKG      WXSP21AM3                      三部東京合計      
 A01 C                   ADD       ECBPURKG      WXSP21AMT                      東京合計          
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01 C                   ENDDO                                                  END-DO2             
 A01  *============================                                                                 
 A01  *                                                                                             
 A01 C                   IF        (WXSP21AMT <> *ZERO)                         IF1                 
 A01 C                   EVAL      WXSP21RT1= %INTH(WXSP21AM1 / WXSP21AMT *100) 一部東京率        
 A01 C                                        / 100                                                 
 A01 C                   EVAL      WXSP21RT2= %INTH(WXSP21AM2 / WXSP21AMT *100) 二部東京率        
 A01 C                                        / 100                                                 
 A01 C                   EVAL      WXSP21RT3= 1 - WXSP21RT1 - WXSP21RT2         三部東京率        
 A01 C                                        / 100                                                 
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01  *============================                                                                 
 A01 C     1             DO        WXKABTSR      IX9                            DO2                 
 A01  *                                                                                             
 A01  *初期化処理-----------                                                                      
 A01 C                   Z-ADD     *ZERO         WXSP21AT                       東京合計旭        
 A01 C                   Z-ADD     *ZERO         WXSP21AT1                      東京合計旭        
 A01 C                   Z-ADD     *ZERO         WXSP21AT2                      東京合計旭        
 A01 C                   MOVEL(P)  *BLANK        WXSP21GENM                     汎用名称          
 A01  *                                                                                             
 A01  *東部営業一部、二部の東京の売上金額を足す                                                   
 A01  *東部営業一部KAKUNIN                                                                        
 A01 C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
 A01 C                   MOVEL(P)  'A251'        WKEGBUCD                       営業部            
 A01 C                   MOVEL(P)  '01110103'    WKBSGECD                       汎用コード        
 A01 C                   MOVEL(P)  WXKABTKB(IX9) WKKABTKB                       型別区分          
 A01 C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
 A01 C     WKKEYTP1      CHAIN(N)  OB6110L01                          80        ワークファイル    
 A01 C  N80              ADD       TPBPURKM      WXSP21AT                       東京合計旭        
 A01 C  N80              MOVEL(P)  TPBSGENM      WXSP21GENM                     汎用名称          
 A01  *                                                                                             
 A01  *東部営業二部                                                                               
 A01 C                   MOVEL(P)  'A257'        WKEGBUCD                       営業部            
 A01 C     WKKEYTP1      CHAIN(N)  OB6110L01                          80        ワークファイル    
 A01 C  N80              ADD       TPBPURKM      WXSP21AT                       東京合計旭        
 A01 C  N80              MOVEL(P)  TPBSGENM      WXSP21GENM                     汎用名称          
 A01  *                                                                                             
 A01  *東部営業三部                                                                               
 A01 C                   MOVEL(P)  'A252'        WKEGBUCD                       営業部            
 A01 C     WKKEYTP1      CHAIN(N)  OB6110L01                          80        ワークファイル    
 A01 C  N80              ADD       TPBPURKM      WXSP21AT                       東京合計旭        
 A01 C  N80              MOVEL(P)  TPBSGENM      WXSP21GENM                     汎用名称          
 A01  *                                                                                             
 A01  *東部営業一部更新-----                                                                      
 A01 C                   EXSR      #WRTSP21A251                                                     
 A01  *東部営業二部更新-----                                                                      
 A01 C                   EXSR      #WRTSP21A257                                                     
 A01  *東部営業三部更新-----                                                                      
 A01 C                   EXSR      #WRTSP21A252                                                     
 A01  *                                                                                             
 A01 C                   ENDDO                                                  END-DO2             
 A01  *============================                                                                 
 A01  *                                                                                             
 A01 C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *特殊条件区分３０---------------                                                            
     C                   IF        (WXSP30FG <> *BLANK)                         IF1                 
      *                                                                                             
      *ＢＰ出荷（明細）読み込み--                                                                 
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   Z-ADD     WXDATE        WKSYORDT                       月次更新日付      
     C     WKKEYEC       SETLL     FBTECL06                                     ＢＰ出荷（明細）  
      *                                                                                             
      *============================                                                                 
     C                   DO        *HIVAL                                       DO2                 
     C                   READ      FBTECL06                               90    ＢＰ出荷（明細）  
     C   90              LEAVE                                                  LEAVE-DO2           
      *                                                                                             
     C                   Z-ADD     ECSYORDT      WXDATE2                        月次更新日付      
     C                   IF        (WXCYM < WXCYM2)                             IF1                 
     C                   LEAVE                                                  LEAVE-DO2           
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *ＢＰ部署マスター情報取得                                                                   
     C                   MOVEL(P)  ECCLNTNO      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  ECOBSYCD      WKOBSYCD                       旧部署コード      
     C                   MOVEL(P)  ECOKYKCD      WKOKYKCD                       旧客先コード      
     C     WKKEYEE       CHAIN     FBMEEL01                           80        部署マスター      
     C   80              ITER                                                   ITER-DO2            
      *                                                                                             
      *特殊条件３０合計                                                                           
     C                   IF        (ECOBSYCD = '55111') AND                     IF1                 
 D02 C***                          (EESYOKCD = 'A')                                                 
 D03 C***                          (EESYOKCD = 'E')                                                 
 A03 C                             (EESYOKCD = 'A')                                                 
     C                   ADD       ECBPURKG      WXSP30AM1                      新潟合計          
     C                   ADD       ECBPURKG      WXSP30AM2                      新潟静岡合計      
     C                   ENDIF                                                  END-IF1             
     C                   IF        (ECOBSYCD = '55131') AND                     IF1                 
     C                             (EESYOKCD = 'C')                                                 
     C                   ADD       ECBPURKG      WXSP30AM2                      新潟静岡合計      
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
     C                   ENDDO                                                  END-DO2             
      *============================                                                                 
      *                                                                                             
     C                   IF        (WXSP30AM2 <> *ZERO)                         IF1                 
     C                   EVAL      WXSP30RT = %INTH(WXSP30AM1 / WXSP30AM2 *100) 特殊条件区分３０率
     C                                        / 100                                                 
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *============================                                                                 
     C     1             DO        WXKABTSR      IXA                            DO2                 
      *                                                                                             
      *初期化処理-----------                                                                      
     C                   Z-ADD     *ZERO         WXSP30A1                       ３０東京合計      
     C                   Z-ADD     *ZERO         WXSP30A2                       ３０東京合計      
     C                   MOVEL(P)  *BLANK        WXSP30GENM                     汎用名称          
      *                                                                                             
      *東部営業二部、中部の東京の売上金額を足す                                                   
      *東部営業二部                                                                               
     C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
 D02 C***                MOVEL(P)  'A252'        WKEGBUCD                       営業部            
 A02 C***                MOVEL(P)  'A257'        WKEGBUCD                       営業部            
 A02 C                   MOVEL(P)  'A252'        WKEGBUCD                       営業部            
     C                   MOVEL(P)  '01110104'    WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKB(IXA) WKKABTKB                       型別区分          
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP1      CHAIN(N)  OB6110L01                          80        ワークファイル    
     C  N80              ADD       TPBPURKM      WXSP30A2                       東京合計旭        
     C  N80              MOVEL(P)  TPBSGENM      WXSP30GENM                     汎用名称          
      *中部営業                                                                                   
     C                   MOVEL(P)  'A253'        WKEGBUCD                       営業部            
     C     WKKEYTP1      CHAIN(N)  OB6110L01                          80        ワークファイル    
     C  N80              ADD       TPBPURKM      WXSP30A2                       東京合計旭        
     C  N80              MOVEL(P)  TPBSGENM      WXSP30GENM                     汎用名称          
      *                                                                                             
      *東部営業二部更新-----                                                                      
     C                   EXSR      #WRTSP30A252                                                     
      *                                                                                             
      *東部営業中部更新-----                                                                      
     C                   EXSR      #WRTSP30A253                                                     
      *                                                                                             
     C                   ENDDO                                                  END-DO2             
      *============================                                                                 
      *                                                                                             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*特殊条件20東部営業一部更新                                                               
     C**********************************************************************                        
     C     #WRTSP20A251  BEGSR                                                                      
      *                                                                                             
      *ファイル読み込み-------------------------                                                  
     C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
     C                   MOVEL(P)  'A251'        WKEGBUCD                       営業部            
     C                   MOVEL(P)  '01110103'    WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKB(IX9) WKKABTKB                       型別区分          
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
      *                                                                                             
     C   81              Z-ADD     WKGTKSYM      TPGTKSYM                       月次更新年月      
     C   81              MOVEL(P)  WKKISOKB      TPKISOKB                       階層区分　　      
     C   81              MOVEL(P)  WKEGBUCD      TPEGBUCD                       営業部            
     C   81              MOVEL(P)  *BLANK        TPEGBUNM                       営業部名称        
     C   81              MOVEL(P)  WKBSGECD      TPBSGECD                       汎用コード        
     C   81              MOVEL(P)  WXSP20GENM    TPBSGENM                       汎用名称　　      
     C   81              MOVEL(P)  WXKABTKB(IX9) TPKABTKB                       型別区分          
     C   81              MOVEL(P)  WXKABTNM(IX9) TPKABTNM                       型別名            
     C   81              Z-ADD     *ZERO         TPBPSKKG                       ＢＰ仕切金額      
     C   81              Z-ADD     *ZERO         TPBPURKG                       ＢＰ売上金額      
     C   81              Z-ADD     *ZERO         TPBSKART                       奨励金掛率        
     C   81              Z-ADD     *ZERO         TPBPSRKG                       奨励金金額        
     C   81              Z-ADD     *ZERO         TPBPSKKM                       ＢＰ仕切金額（元）
     C   81              Z-ADD     *ZERO         TPBPURKM                       ＢＰ売上金額（元）
     C   81              Z-ADD     *ZERO         TPBPSRKM                       奨励金金額（元）  
     C   81              MOVEL(P)  *BLANK        TPBSTNKB                       奨励金算出単位    
     C   81              MOVEL(P)  *BLANK        TPBSMRKB                       奨励金丸め区分    
     C   81              MOVEL(P)  *BLANK        TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *ＢＰ奨励金条件マスタ情報取得---                                                            
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
     C                   Z-ADD     WXCYM         WKFRMNDT                       適用月度FROM      
     C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
     C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
     C   80              CLEAR     *ALL          FBMBSR02                       奨励金条件マスタ  
     C   81              MOVEL(P)  BSBSTNKB      TPBSTNKB                       奨励金算出単位    
     C   81              MOVEL(P)  BSBSMRKB      TPBSMRKB                       奨励金丸め区分    
     C   81              MOVEL(P)  BSBSMTKB      TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *営業所名取得-------------------                                                            
     C                   IF        (*IN81 = *ON)                                IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
     C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
     C                   MOVEL(P)  TPEGBUCD      WKVKBUR                        営業所            
     C     WKKEYPE       CHAIN     FSSPEL01                           80                            
     C  N80              MOVEL(P)  PEBEZEI       TPEGBUNM                       営業部名称        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金掛率取得-----------------                                                            
     C                   IF        (*IN81 = *ON)                                IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   Z-ADD     BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '40'          WKBSJKKB                       奨励金条件区分    
     C                   MOVEL(P)  TPKABTKB      WKKKRHKB                       型別　：掛率　    
     C     WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C   80              MOVEL(P)  *BLANK        WKKKRHKB                       型別　：掛率　    
     C   80WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C  N80              Z-ADD     BTBSKART      TPBSKART                       奨励金掛率        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
     C                   EVAL      TPBPSRKG = WXSP20A2 * WXSP20RT               奨励金金額        
     C                                        * TPBSKART / 100                                      
     C                   Z-ADD     TPBPSRKG      TPBPSRKM                       奨励金金額元      
      *                                                                                             
      *丸め処理---                                                                                
      *ＢＰ仕切金額                                                                               
     C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
      *ＢＰ売上金額                                                                               
     C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
      *奨励金金額                                                                                 
     C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
      *                                                                                             
      *更新処理---                                                                                
     C   81              WRITE     OB6110R01                                    ワークファイル    
     C  N81              UPDATE    OB6110R01                                    ワークファイル    
      *                                                                                             
      *                                                                                             
     C                   EVAL      WXSP20A1 = WXSP20A2 * WXSP20RT               一部東京合計旭    
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*特殊条件20東部営業一部更新                                                               
     C**********************************************************************                        
     C     #WRTSP20A252  BEGSR                                                                      
      *                                                                                             
      *ファイル読み込み-------------------------                                                  
     C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
 D03 C***                MOVEL(P)  'A252'        WKEGBUCD                       営業部            
 A03 C***                MOVEL(P)  'A257'        WKEGBUCD                       営業部            
 A03 C                   MOVEL(P)  'A252'        WKEGBUCD                       営業部            
     C                   MOVEL(P)  '01110103'    WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKB(IX9) WKKABTKB                       型別区分          
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
      *                                                                                             
     C   81              Z-ADD     WKGTKSYM      TPGTKSYM                       月次更新年月      
     C   81              MOVEL(P)  WKKISOKB      TPKISOKB                       階層区分　　      
     C   81              MOVEL(P)  WKEGBUCD      TPEGBUCD                       営業部            
     C   81              MOVEL(P)  *BLANK        TPEGBUNM                       営業部名称        
     C   81              MOVEL(P)  WKBSGECD      TPBSGECD                       汎用コード        
     C   81              MOVEL(P)  WXSP20GENM    TPBSGENM                       汎用名称          
     C   81              MOVEL(P)  WXKABTKB(IX9) TPKABTKB                       型別区分          
     C   81              MOVEL(P)  WXKABTNM(IX9) TPKABTNM                       型別名            
     C   81              Z-ADD     *ZERO         TPBPSKKG                       ＢＰ仕切金額      
     C   81              Z-ADD     *ZERO         TPBPURKG                       ＢＰ売上金額      
     C   81              Z-ADD     *ZERO         TPBSKART                       奨励金掛率        
     C   81              Z-ADD     *ZERO         TPBPSRKG                       奨励金金額        
     C   81              Z-ADD     *ZERO         TPBPSKKM                       ＢＰ仕切金額（元）
     C   81              Z-ADD     *ZERO         TPBPURKM                       ＢＰ売上金額（元）
     C   81              Z-ADD     *ZERO         TPBPSRKM                       奨励金金額（元）  
     C   81              MOVEL(P)  *BLANK        TPBSTNKB                       奨励金算出単位    
     C   81              MOVEL(P)  *BLANK        TPBSMRKB                       奨励金丸め区分    
     C   81              MOVEL(P)  *BLANK        TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *ＢＰ奨励金条件マスタ情報取得---                                                            
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
     C                   Z-ADD     WXCYM         WKFRMNDT                       適用月度FROM      
     C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
     C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
     C   80              CLEAR     *ALL          FBMBSR02                       奨励金条件マスタ  
     C   81              MOVEL(P)  BSBSTNKB      TPBSTNKB                       奨励金算出単位    
     C   81              MOVEL(P)  BSBSMRKB      TPBSMRKB                       奨励金丸め区分    
     C   81              MOVEL(P)  BSBSMTKB      TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *営業所名取得-------------------                                                            
     C                   IF        (*IN81 = *ON)                                IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
     C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
     C                   MOVEL(P)  TPEGBUCD      WKVKBUR                        営業所            
     C     WKKEYPE       CHAIN     FSSPEL01                           80                            
     C  N80              MOVEL(P)  PEBEZEI       TPEGBUNM                       営業部名称        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金掛率取得-----------------                                                            
     C                   IF        (*IN81 = *ON)                                IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   Z-ADD     BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '40'          WKBSJKKB                       奨励金条件区分    
     C                   MOVEL(P)  TPKABTKB      WKKKRHKB                       型別　：掛率　    
     C     WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C   80              MOVEL(P)  *BLANK        WKKKRHKB                       型別　：掛率　    
     C   80WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C  N80              Z-ADD     BTBSKART      TPBSKART                       奨励金掛率        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
     C                   EVAL      TPBPSRKG = (WXSP20A2 - WXSP20A1)             奨励金金額        
     C                                        * TPBSKART / 100                                      
     C                   Z-ADD     TPBPSRKG      TPBPSRKM                       奨励金金額元      
      *                                                                                             
      *丸め処理---                                                                                
      *ＢＰ仕切金額                                                                               
     C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
      *ＢＰ売上金額                                                                               
     C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
      *奨励金金額                                                                                 
     C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
      *                                                                                             
      *更新処理---                                                                                
     C   81              WRITE     OB6110R01                                    ワークファイル    
     C  N81              UPDATE    OB6110R01                                    ワークファイル    
      *                                                                                             
     C                   ENDSR                                                                      
 A01 C**********************************************************************                        
 A01 C*特殊条件21東部営業一部更新                                                               
 A01 C**********************************************************************                        
 A01 C     #WRTSP21A251  BEGSR                                                                      
 A01  *                                                                                             
 A01  *ファイル読み込み-------------------------    KAKUNIN                                       
 A01 C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
 A01 C                   MOVEL(P)  'A251'        WKEGBUCD                       営業部            
 A01 C                   MOVEL(P)  '01110103'    WKBSGECD                       汎用コード        
 A01 C                   MOVEL(P)  WXKABTKB(IX9) WKKABTKB                       型別区分          
 A01 C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
 A01 C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
 A01  *                                                                                             
 A01  *パラメータセット-------------------------                                                  
 A01 C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
 A01  *                                                                                             
 A01 C   81              Z-ADD     WKGTKSYM      TPGTKSYM                       月次更新年月      
 A01 C   81              MOVEL(P)  WKKISOKB      TPKISOKB                       階層区分　　      
 A01 C   81              MOVEL(P)  WKEGBUCD      TPEGBUCD                       営業部            
 A01 C   81              MOVEL(P)  *BLANK        TPEGBUNM                       営業部名称        
 A01 C   81              MOVEL(P)  WKBSGECD      TPBSGECD                       汎用コード        
 A01 C   81              MOVEL(P)  WXSP21GENM    TPBSGENM                       汎用名称　　      
 A01 C   81              MOVEL(P)  WXKABTKB(IX9) TPKABTKB                       型別区分          
 A01 C   81              MOVEL(P)  WXKABTNM(IX9) TPKABTNM                       型別名            
 A01 C   81              Z-ADD     *ZERO         TPBPSKKG                       ＢＰ仕切金額      
 A01 C   81              Z-ADD     *ZERO         TPBPURKG                       ＢＰ売上金額      
 A01 C   81              Z-ADD     *ZERO         TPBSKART                       奨励金掛率        
 A01 C   81              Z-ADD     *ZERO         TPBPSRKG                       奨励金金額        
 A01 C   81              Z-ADD     *ZERO         TPBPSKKM                       ＢＰ仕切金額（元）
 A01 C   81              Z-ADD     *ZERO         TPBPURKM                       ＢＰ売上金額（元）
 A01 C   81              Z-ADD     *ZERO         TPBPSRKM                       奨励金金額（元）  
 A01 C   81              MOVEL(P)  *BLANK        TPBSTNKB                       奨励金算出単位    
 A01 C   81              MOVEL(P)  *BLANK        TPBSMRKB                       奨励金丸め区分    
 A01 C   81              MOVEL(P)  *BLANK        TPBSMTKB                       奨励金丸め単位    
 A01  *                                                                                             
 A01  *ＢＰ奨励金条件マスタ情報取得---                                                            
 A01 C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
 A01 C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
 A01 C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
 A01 C                   Z-ADD     WXCYM         WKFRMNDT                       適用月度FROM      
 A01 C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
 A01 C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
 A01 C   80              CLEAR     *ALL          FBMBSR02                       奨励金条件マスタ  
 A01 C   81              MOVEL(P)  BSBSTNKB      TPBSTNKB                       奨励金算出単位    
 A01 C   81              MOVEL(P)  BSBSMRKB      TPBSMRKB                       奨励金丸め区分    
 A01 C   81              MOVEL(P)  BSBSMTKB      TPBSMTKB                       奨励金丸め単位    
 A01  *                                                                                             
 A01  *営業所名取得-------------------                                                            
 A01 C                   IF        (*IN81 = *ON)                                IF1                 
 A01 C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
 A01 C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
 A01 C                   MOVEL(P)  TPEGBUCD      WKVKBUR                        営業所            
 A01 C     WKKEYPE       CHAIN     FSSPEL01                           80                            
 A01 C  N80              MOVEL(P)  PEBEZEI       TPEGBUNM                       営業部名称        
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01  *奨励金掛率取得-----------------                                                            
 A01 C                   IF        (*IN81 = *ON)                                IF1                 
 A01 C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
 A01 C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
 A01 C                   Z-ADD     BSFRMNDT      WKFRMNDT                       適用月度FROM      
 A01 C                   MOVEL(P)  '40'          WKBSJKKB                       奨励金条件区分    
 A01 C                   MOVEL(P)  TPKABTKB      WKKKRHKB                       型別　：掛率　    
 A01 C     WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
 A01 C   80              MOVEL(P)  *BLANK        WKKKRHKB                       型別　：掛率　    
 A01 C   80WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
 A01 C  N80              Z-ADD     BTBSKART      TPBSKART                       奨励金掛率        
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01 C                   EVAL      TPBPSRKG = WXSP21AT * WXSP21RT1              奨励金金額        
 A01 C                                        * TPBSKART / 100                                      
 A01 C                   Z-ADD     TPBPSRKG      TPBPSRKM                       奨励金金額元      
 A01  *                                                                                             
 A01 C                   EVAL      WXSP21AT1= WXSP21AT * WXSP21RT1              奨励金金額        
 A01  *                                                                                             
 A01  *丸め処理---                                                                                
 A01  *ＢＰ仕切金額                                                                               
 A01 C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
 A01  *ＢＰ売上金額                                                                               
 A01 C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
 A01  *奨励金金額                                                                                 
 A01 C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
 A01  *                                                                                             
 A01  *更新処理---                                                                                
 A01 C   81              WRITE     OB6110R01                                    ワークファイル    
 A01 C  N81              UPDATE    OB6110R01                                    ワークファイル    
 A01  *                                                                                             
 A01 C                   ENDSR                                                                      
 A01 C**********************************************************************                        
 A01 C*特殊条件21東部営業二部更新                                                               
 A01 C**********************************************************************                        
 A01 C     #WRTSP21A257  BEGSR                                                                      
 A01  *                                                                                             
 A01  *ファイル読み込み-------------------------                                                  
 A01 C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
 A01 C                   MOVEL(P)  'A257'        WKEGBUCD                       ※これが２部      
 A01 C                   MOVEL(P)  '01110103'    WKBSGECD                       汎用コード        
 A01 C                   MOVEL(P)  WXKABTKB(IX9) WKKABTKB                       型別区分          
 A01 C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
 A01 C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
 A01  *                                                                                             
 A01  *パラメータセット-------------------------                                                  
 A01 C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
 A01  *                                                                                             
 A01 C   81              Z-ADD     WKGTKSYM      TPGTKSYM                       月次更新年月      
 A01 C   81              MOVEL(P)  WKKISOKB      TPKISOKB                       階層区分　　      
 A01 C   81              MOVEL(P)  WKEGBUCD      TPEGBUCD                       営業部            
 A01 C   81              MOVEL(P)  *BLANK        TPEGBUNM                       営業部名称        
 A01 C   81              MOVEL(P)  WKBSGECD      TPBSGECD                       汎用コード        
 A01 C   81              MOVEL(P)  WXSP21GENM    TPBSGENM                       汎用名称          
 A01 C   81              MOVEL(P)  WXKABTKB(IX9) TPKABTKB                       型別区分          
 A01 C   81              MOVEL(P)  WXKABTNM(IX9) TPKABTNM                       型別名            
 A01 C   81              Z-ADD     *ZERO         TPBPSKKG                       ＢＰ仕切金額      
 A01 C   81              Z-ADD     *ZERO         TPBPURKG                       ＢＰ売上金額      
 A01 C   81              Z-ADD     *ZERO         TPBSKART                       奨励金掛率        
 A01 C   81              Z-ADD     *ZERO         TPBPSRKG                       奨励金金額        
 A01 C   81              Z-ADD     *ZERO         TPBPSKKM                       ＢＰ仕切金額（元）
 A01 C   81              Z-ADD     *ZERO         TPBPURKM                       ＢＰ売上金額（元）
 A01 C   81              Z-ADD     *ZERO         TPBPSRKM                       奨励金金額（元）  
 A01 C   81              MOVEL(P)  *BLANK        TPBSTNKB                       奨励金算出単位    
 A01 C   81              MOVEL(P)  *BLANK        TPBSMRKB                       奨励金丸め区分    
 A01 C   81              MOVEL(P)  *BLANK        TPBSMTKB                       奨励金丸め単位    
 A01  *                                                                                             
 A01  *ＢＰ奨励金条件マスタ情報取得---                                                            
 A01 C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
 A01 C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
 A01 C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
 A01 C                   Z-ADD     WXCYM         WKFRMNDT                       適用月度FROM      
 A01 C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
 A01 C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
 A01 C   80              CLEAR     *ALL          FBMBSR02                       奨励金条件マスタ  
 A01 C   81              MOVEL(P)  BSBSTNKB      TPBSTNKB                       奨励金算出単位    
 A01 C   81              MOVEL(P)  BSBSMRKB      TPBSMRKB                       奨励金丸め区分    
 A01 C   81              MOVEL(P)  BSBSMTKB      TPBSMTKB                       奨励金丸め単位    
 A01  *                                                                                             
 A01  *営業所名取得-------------------                                                            
 A01 C                   IF        (*IN81 = *ON)                                IF1                 
 A01 C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
 A01 C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
 A01 C                   MOVEL(P)  TPEGBUCD      WKVKBUR                        営業所            
 A01 C     WKKEYPE       CHAIN     FSSPEL01                           80                            
 A01 C  N80              MOVEL(P)  PEBEZEI       TPEGBUNM                       営業部名称        
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01  *奨励金掛率取得-----------------                                                            
 A01 C                   IF        (*IN81 = *ON)                                IF1                 
 A01 C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
 A01 C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
 A01 C                   Z-ADD     BSFRMNDT      WKFRMNDT                       適用月度FROM      
 A01 C                   MOVEL(P)  '40'          WKBSJKKB                       奨励金条件区分    
 A01 C                   MOVEL(P)  TPKABTKB      WKKKRHKB                       型別　：掛率　    
 A01 C     WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
 A01 C   80              MOVEL(P)  *BLANK        WKKKRHKB                       型別　：掛率　    
 A01 C   80WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
 A01 C  N80              Z-ADD     BTBSKART      TPBSKART                       奨励金掛率        
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01 C                   EVAL      TPBPSRKG = WXSP21AT * WXSP21RT2              奨励金金額        
 A01 C                                        * TPBSKART / 100                                      
 A01 C                   Z-ADD     TPBPSRKG      TPBPSRKM                       奨励金金額元      
 A01  *                                                                                             
 A01 C                   EVAL      WXSP21AT2= WXSP21AT * WXSP21RT2              奨励金金額        
 A01  *                                                                                             
 A01  *丸め処理---                                                                                
 A01  *ＢＰ仕切金額                                                                               
 A01 C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
 A01  *ＢＰ売上金額                                                                               
 A01 C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
 A01  *奨励金金額                                                                                 
 A01 C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
 A01  *                                                                                             
 A01  *更新処理---                                                                                
 A01 C   81              WRITE     OB6110R01                                    ワークファイル    
 A01 C  N81              UPDATE    OB6110R01                                    ワークファイル    
 A01  *                                                                                             
 A01 C                   ENDSR                                                                      
 A01 C**********************************************************************                        
 A01 C*特殊条件21東部営業三部更新                                                               
 A01 C**********************************************************************                        
 A01 C     #WRTSP21A252  BEGSR                                                                      
 A01  *                                                                                             
 A01  *ファイル読み込み-------------------------                                                  
 A01 C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
 A01 C                   MOVEL(P)  'A252'        WKEGBUCD                       ※これが３部      
 A01 C                   MOVEL(P)  '01110103'    WKBSGECD                       汎用コード        
 A01 C                   MOVEL(P)  WXKABTKB(IX9) WKKABTKB                       型別区分          
 A01 C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
 A01 C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
 A01  *                                                                                             
 A01  *パラメータセット-------------------------                                                  
 A01 C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
 A01  *                                                                                             
 A01 C   81              Z-ADD     WKGTKSYM      TPGTKSYM                       月次更新年月      
 A01 C   81              MOVEL(P)  WKKISOKB      TPKISOKB                       階層区分　　      
 A01 C   81              MOVEL(P)  WKEGBUCD      TPEGBUCD                       営業部            
 A01 C   81              MOVEL(P)  *BLANK        TPEGBUNM                       営業部名称        
 A01 C   81              MOVEL(P)  WKBSGECD      TPBSGECD                       汎用コード        
 A01 C   81              MOVEL(P)  WXSP21GENM    TPBSGENM                       汎用名称          
 A01 C   81              MOVEL(P)  WXKABTKB(IX9) TPKABTKB                       型別区分          
 A01 C   81              MOVEL(P)  WXKABTNM(IX9) TPKABTNM                       型別名            
 A01 C   81              Z-ADD     *ZERO         TPBPSKKG                       ＢＰ仕切金額      
 A01 C   81              Z-ADD     *ZERO         TPBPURKG                       ＢＰ売上金額      
 A01 C   81              Z-ADD     *ZERO         TPBSKART                       奨励金掛率        
 A01 C   81              Z-ADD     *ZERO         TPBPSRKG                       奨励金金額        
 A01 C   81              Z-ADD     *ZERO         TPBPSKKM                       ＢＰ仕切金額（元）
 A01 C   81              Z-ADD     *ZERO         TPBPURKM                       ＢＰ売上金額（元）
 A01 C   81              Z-ADD     *ZERO         TPBPSRKM                       奨励金金額（元）  
 A01 C   81              MOVEL(P)  *BLANK        TPBSTNKB                       奨励金算出単位    
 A01 C   81              MOVEL(P)  *BLANK        TPBSMRKB                       奨励金丸め区分    
 A01 C   81              MOVEL(P)  *BLANK        TPBSMTKB                       奨励金丸め単位    
 A01  *                                                                                             
 A01  *ＢＰ奨励金条件マスタ情報取得---                                                            
 A01 C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
 A01 C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
 A01 C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
 A01 C                   Z-ADD     WXCYM         WKFRMNDT                       適用月度FROM      
 A01 C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
 A01 C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
 A01 C   80              CLEAR     *ALL          FBMBSR02                       奨励金条件マスタ  
 A01 C   81              MOVEL(P)  BSBSTNKB      TPBSTNKB                       奨励金算出単位    
 A01 C   81              MOVEL(P)  BSBSMRKB      TPBSMRKB                       奨励金丸め区分    
 A01 C   81              MOVEL(P)  BSBSMTKB      TPBSMTKB                       奨励金丸め単位    
 A01  *                                                                                             
 A01  *営業所名取得-------------------                                                            
 A01 C                   IF        (*IN81 = *ON)                                IF1                 
 A01 C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
 A01 C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
 A01 C                   MOVEL(P)  TPEGBUCD      WKVKBUR                        営業所            
 A01 C     WKKEYPE       CHAIN     FSSPEL01                           80                            
 A01 C  N80              MOVEL(P)  PEBEZEI       TPEGBUNM                       営業部名称        
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01  *奨励金掛率取得-----------------                                                            
 A01 C                   IF        (*IN81 = *ON)                                IF1                 
 A01 C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
 A01 C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
 A01 C                   Z-ADD     BSFRMNDT      WKFRMNDT                       適用月度FROM      
 A01 C                   MOVEL(P)  '40'          WKBSJKKB                       奨励金条件区分    
 A01 C                   MOVEL(P)  TPKABTKB      WKKKRHKB                       型別　：掛率　    
 A01 C     WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
 A01 C   80              MOVEL(P)  *BLANK        WKKKRHKB                       型別　：掛率　    
 A01 C   80WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
 A01 C  N80              Z-ADD     BTBSKART      TPBSKART                       奨励金掛率        
 A01 C                   ENDIF                                                  END-IF1             
 A01  *                                                                                             
 A01 C                   EVAL      TPBPSRKG = (WXSP21AT - WXSP21AT1 -           奨励金金額        
 A01 C                                         WXSP21AT2)                                           
 A01 C                                        * TPBSKART / 100                                      
 A01 C                   Z-ADD     TPBPSRKG      TPBPSRKM                       奨励金金額元      
 A01  *                                                                                             
 A01  *丸め処理---                                                                                
 A01  *ＢＰ仕切金額                                                                               
 A01 C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
 A01  *ＢＰ売上金額                                                                               
 A01 C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
 A01  *奨励金金額                                                                                 
 A01 C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
 A01 C                   EXSR      #PROCMR                                                          
 A01 C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
 A01  *                                                                                             
 A01  *更新処理---                                                                                
 A01 C   81              WRITE     OB6110R01                                    ワークファイル    
 A01 C  N81              UPDATE    OB6110R01                                    ワークファイル    
 A01  *                                                                                             
 A01 C                   ENDSR                                                                      
     C**********************************************************************                        
     C*特殊条件30東部営業二部更新                                                               
     C**********************************************************************                        
     C     #WRTSP30A252  BEGSR                                                                      
      *                                                                                             
      *ファイル読み込み-------------------------                                                  
     C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
 D02 C                   MOVEL(P)  'A252'        WKEGBUCD                       営業部            
 A02 C***                MOVEL(P)  'A257'        WKEGBUCD                       営業部            
     C                   MOVEL(P)  '01110104'    WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKB(IXA) WKKABTKB                       型別区分          
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
      *                                                                                             
     C   81              Z-ADD     WKGTKSYM      TPGTKSYM                       月次更新年月      
     C   81              MOVEL(P)  WKKISOKB      TPKISOKB                       階層区分　　      
     C   81              MOVEL(P)  WKEGBUCD      TPEGBUCD                       営業部            
     C   81              MOVEL(P)  *BLANK        TPEGBUNM                       営業部名称        
     C   81              MOVEL(P)  WKBSGECD      TPBSGECD                       汎用コード        
     C   81              MOVEL(P)  WXSP30GENM    TPBSGENM                       汎用名称　　      
     C   81              MOVEL(P)  WXKABTKB(IXA) TPKABTKB                       型別区分          
     C   81              MOVEL(P)  WXKABTNM(IXA) TPKABTNM                       型別名            
     C   81              Z-ADD     *ZERO         TPBPSKKG                       ＢＰ仕切金額      
     C   81              Z-ADD     *ZERO         TPBPURKG                       ＢＰ売上金額      
     C   81              Z-ADD     *ZERO         TPBSKART                       奨励金掛率        
     C   81              Z-ADD     *ZERO         TPBPSRKG                       奨励金金額        
     C   81              Z-ADD     *ZERO         TPBPSKKM                       ＢＰ仕切金額（元）
     C   81              Z-ADD     *ZERO         TPBPURKM                       ＢＰ売上金額（元）
     C   81              Z-ADD     *ZERO         TPBPSRKM                       奨励金金額（元）  
     C   81              MOVEL(P)  *BLANK        TPBSTNKB                       奨励金算出単位    
     C   81              MOVEL(P)  *BLANK        TPBSMRKB                       奨励金丸め区分    
     C   81              MOVEL(P)  *BLANK        TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *ＢＰ奨励金条件マスタ情報取得---                                                            
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
     C                   Z-ADD     WXCYM         WKFRMNDT                       適用月度FROM      
     C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
     C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
     C   80              CLEAR     *ALL          FBMBSR02                       奨励金条件マスタ  
     C   81              MOVEL(P)  BSBSTNKB      TPBSTNKB                       奨励金算出単位    
     C   81              MOVEL(P)  BSBSMRKB      TPBSMRKB                       奨励金丸め区分    
     C   81              MOVEL(P)  BSBSMTKB      TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *営業所名取得-------------------                                                            
     C                   IF        (*IN81 = *ON)                                IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
     C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
     C                   MOVEL(P)  TPEGBUCD      WKVKBUR                        営業所            
     C     WKKEYPE       CHAIN     FSSPEL01                           80                            
     C  N80              MOVEL(P)  PEBEZEI       TPEGBUNM                       営業部名称        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金掛率取得-----------------                                                            
     C                   IF        (*IN81 = *ON)                                IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   Z-ADD     BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '40'          WKBSJKKB                       奨励金条件区分    
     C                   MOVEL(P)  TPKABTKB      WKKKRHKB                       型別　：掛率　    
     C     WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C   80              MOVEL(P)  *BLANK        WKKKRHKB                       型別　：掛率　    
     C   80WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C  N80              Z-ADD     BTBSKART      TPBSKART                       奨励金掛率        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
     C                   EVAL      TPBPSRKG = WXSP30A2 * WXSP30RT               奨励金金額        
     C                                        * TPBSKART / 100                                      
     C                   Z-ADD     TPBPSRKG      TPBPSRKM                       奨励金金額元      
      *                                                                                             
      *丸め処理---                                                                                
      *ＢＰ仕切金額                                                                               
     C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
      *ＢＰ売上金額                                                                               
     C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
      *奨励金金額                                                                                 
     C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
      *                                                                                             
      *更新処理---                                                                                
     C   81              WRITE     OB6110R01                                    ワークファイル    
     C  N81              UPDATE    OB6110R01                                    ワークファイル    
      *                                                                                             
      *                                                                                             
     C                   EVAL      WXSP30A1 = WXSP30A2 * WXSP30RT               ３０東京合計      
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*特殊条件30中部営業更新                                                                   
     C**********************************************************************                        
     C     #WRTSP30A253  BEGSR                                                                      
      *                                                                                             
      *ファイル読み込み-------------------------                                                  
     C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
     C                   MOVEL(P)  'A253'        WKEGBUCD                       営業部            
     C                   MOVEL(P)  '01110104'    WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKB(IXA) WKKABTKB                       型別区分          
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
      *                                                                                             
     C   81              Z-ADD     WKGTKSYM      TPGTKSYM                       月次更新年月      
     C   81              MOVEL(P)  WKKISOKB      TPKISOKB                       階層区分　　      
     C   81              MOVEL(P)  WKEGBUCD      TPEGBUCD                       営業部            
     C   81              MOVEL(P)  *BLANK        TPEGBUNM                       営業部名称        
     C   81              MOVEL(P)  WKBSGECD      TPBSGECD                       汎用コード        
     C   81              MOVEL(P)  WXSP30GENM    TPBSGENM                       汎用名称　        
     C   81              MOVEL(P)  WXKABTKB(IXA) TPKABTKB                       型別区分          
     C   81              MOVEL(P)  WXKABTNM(IXA) TPKABTNM                       型別名            
     C   81              Z-ADD     *ZERO         TPBPSKKG                       ＢＰ仕切金額      
     C   81              Z-ADD     *ZERO         TPBPURKG                       ＢＰ売上金額      
     C   81              Z-ADD     *ZERO         TPBSKART                       奨励金掛率        
     C   81              Z-ADD     *ZERO         TPBPSRKG                       奨励金金額        
     C   81              Z-ADD     *ZERO         TPBPSKKM                       ＢＰ仕切金額（元）
     C   81              Z-ADD     *ZERO         TPBPURKM                       ＢＰ売上金額（元）
     C   81              Z-ADD     *ZERO         TPBPSRKM                       奨励金金額（元）  
     C   81              MOVEL(P)  *BLANK        TPBSTNKB                       奨励金算出単位    
     C   81              MOVEL(P)  *BLANK        TPBSMRKB                       奨励金丸め区分    
     C   81              MOVEL(P)  *BLANK        TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *ＢＰ奨励金条件マスタ情報取得---                                                            
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
     C                   Z-ADD     WXCYM         WKFRMNDT                       適用月度FROM      
     C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
     C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
     C   80              CLEAR     *ALL          FBMBSR02                       奨励金条件マスタ  
     C   81              MOVEL(P)  BSBSTNKB      TPBSTNKB                       奨励金算出単位    
     C   81              MOVEL(P)  BSBSMRKB      TPBSMRKB                       奨励金丸め区分    
     C   81              MOVEL(P)  BSBSMTKB      TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *営業所名取得-------------------                                                            
     C                   IF        (*IN81 = *ON)                                IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
     C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
     C                   MOVEL(P)  TPEGBUCD      WKVKBUR                        営業所            
     C     WKKEYPE       CHAIN     FSSPEL01                           80                            
     C  N80              MOVEL(P)  PEBEZEI       TPEGBUNM                       営業部名称        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金掛率取得-----------------                                                            
     C                   IF        (*IN81 = *ON)                                IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   Z-ADD     BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '40'          WKBSJKKB                       奨励金条件区分    
     C                   MOVEL(P)  TPKABTKB      WKKKRHKB                       型別　：掛率　    
     C     WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C   80              MOVEL(P)  *BLANK        WKKKRHKB                       型別　：掛率　    
     C   80WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C  N80              Z-ADD     BTBSKART      TPBSKART                       奨励金掛率        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
     C                   EVAL      TPBPSRKG = (WXSP30A2 - WXSP30A1)             奨励金金額        
     C                                        * TPBSKART / 100                                      
     C                   Z-ADD     TPBPSRKG      TPBPSRKM                       奨励金金額元      
      *                                                                                             
      *丸め処理---                                                                                
      *ＢＰ仕切金額                                                                               
     C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
      *ＢＰ売上金額                                                                               
     C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
      *奨励金金額                                                                                 
     C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
      *                                                                                             
      *更新処理---                                                                                
     C   81              WRITE     OB6110R01                                    ワークファイル    
     C  N81              UPDATE    OB6110R01                                    ワークファイル    
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*メイン処理                                                                                 
     C**********************************************************************                        
     C     #MAIN         BEGSR                                                                      
      *                                                                                             
      *明細                                                                                       
     C                   EXSR      #PROCD                                                           
      *                                                                                             
      *型一覧取得                                                                                 
     C                   EXSR      #GETKABT                                                         
      *                                                                                             
      *特殊条件区分２０関連前処理                                                                 
     C                   EXSR      #SPKB20                                                          
      *                                                                                             
      *明細空データ作成                                                                           
     C                   EXSR      #PROCAD                                                          
      *                                                                                             
      *小計データ作成                                                                             
     C                   EXSR      #PROCSK                                                          
      *                                                                                             
      *総合計データ作成                                                                           
     C                   EXSR      #PROCGK                                                          
      *                                                                                             
      *月別計データ作成                                                                           
     C                   EXSR      #PROCDM                                                          
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*                                                                                             
     C**********************************************************************                        
     C     #PROCD        BEGSR                                                                      
      *                                                                                             
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   Z-ADD     WXSTATDT      WKSYORDT                       月次更新日付      
     C     WKKEYEC       SETLL     FBTECL06                                     ＢＰ出荷（明細）  
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
      *ファイル読み込み---------------                                                            
     C                   EXSR      #READEC                                      ＢＰ出荷（明細）  
     C   90              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
      *ワークファイル書き出し                                                                     
     C                   EXSR      #WRTTP10                                                         
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*ＢＰ奨励金条件マスタ見出読み込み                                                           
     C**********************************************************************                        
     C     #READEC       BEGSR                                                                      
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
YS1  C                   READ      FBTECL06                               90    ＢＰ出荷（明細）  
     C   90              LEAVE                                                                      
      *                                                                                             
     C                   SETOFF                                       88                            
      *                                                                                             
      *各種チェック処理-------------------------                                                  
      *対象日付を過ぎたら終了---------                                                            
     C                   IF        (WXENDDT <= ECSYORDT)                        IF1                 
     C                   SETON                                        90        LEAVE-DO1           
     C                   LEAVE                                                  LEAVE-DO1           
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *売上金額0データは除外--------                                                            
     C                   IF        (ECBPURKG = *ZERO)                           IF1                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *ＢＰ奨励金条件マスタ情報取得---                                                            
     C                   IF        (WXGTKSYMB <> WXGTKSYM)                      IF1                 
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  WIBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  WIBSSHKB      WKBSSHKB                       奨励金集約区分    
     C                   Z-ADD     WXGTKSYM      WKFRMNDT                       適用月度FROM      
     C     WKKEYBS1      SETGT     FBMBSL02                                     奨励金条件マスタ  
     C     WKKEYBS2      READPE    FBMBSL02                               80    奨励金条件マスタ  
     C   80              ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF1             
     C                   Z-ADD     WXGTKSYM      WXGTKSYMB                      月次更新年月BK    
      *                                                                                             
     C   50              MOVEL(P)  ECOBSYCD      WXBSGEC2                       旧部署コード      
     C   50              MOVEL(P)  ECOBSYNM      WXBSGEN2                       旧部署名          
     C   51              MOVEL(P)  ECOKYKCD      WXBSGEC2                       旧客先コード      
     C   51              MOVEL(P)  ECOKYKNM      WXBSGEN2                       旧客先名          
     C   52              MOVEL(P)  ECTKYKCD      WXBSGEC2                       特施工コード      
     C   52              MOVEL(P)  ECTKKJNM      WXBSGEN2                       特施工店名称      
     C   53              MOVEL(P)  ECGADSCD      WXBSGEC2                       現場住所コード都道
     C   53              MOVEL(P)  *BLANK        WXBSGEN2                       住所名漢          
      *                                                                                             
      *小計名称取得-------------------                                                            
     C                   SELECT                                                 SL1                 
      *特施工店別-----------                                                                      
     C                   WHEN      (*IN52 = *ON)                                WHEN-SL1            
      *ＢＰ特施工マスター情報取得                                                                 
     C                   MOVEL(P)  *BLANK        TPEGBUCD                       営業部            
      *                                                                                             
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  WXBSGEC2      WKTKYKCD                       特施工コード      
     C     WKKEYEH       CHAIN     FBMEHL01                           80        特施工マスター    
     C  N80              MOVEL(P)  EHSYRBKB      WXEGBUC2                       営業部            
     C  N80              MOVEL(P)  EHSYRBNM      WXEGBUN2                       営業部名称        
      *                                                                                             
      *都道府県別-----------                                                                      
     C                   WHEN      (*IN53 = *ON)                                WHEN-SL1            
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  ECGADSCD      WKFUKNCD                       府県コード        
     C     WKKEYEI       CHAIN     FBMEIL01                           80                            
     C  N80              MOVEL(P)  EIJUSYKN      WXBSGEN2                       住所名漢          
      *                                                                                             
     C                   MOVEL(P)  EIZNKTCD      WXEGBUC2                       営業部            
     C                   MOVEL(P)  EITIKUNM      WXEGBUN2                       営業部名称        
      *                                                                                             
      *その他---------------                                                                      
     C                   OTHER                                                  OTHER-SL1           
      *営業所名取得                                                                               
     C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
     C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
     C                   MOVEL(P)  ECEGBUCD      WKVKBUR                        営業所            
     C     WKKEYPE       CHAIN     FSSPEL01                           80                            
     C  N80              MOVEL(P)  ECEGBUCD      WXEGBUC2                       営業部            
     C  N80              MOVEL(P)  PEBEZEI       WXEGBUN2                       営業部名称        
     C                   ENDSL                                                  END-SL1             
      *                                                                                             
      *対象条件チェック---------------                                                            
     C                   EXSR      #CHK10                                                           
     C   88              ITER                                                   ITER-DO1            
      *                                                                                             
      *除外条件チェック---------------                                                            
     C                   EXSR      #CHK20                                                           
     C   88              ITER                                                   ITER-DO1            
      *                                                                                             
      *集約条件チェック---------------                                                            
     C                   EXSR      #CHK30                                                           
     C   88              ITER                                                   ITER-DO1            
YS2   *                                                                                             
YS2   *特殊条件チェック---------------                                                            
      *Ｉ型・Ｉ型Ｖ列結合                                                                         
     C                   MOVEL(P)  BSCLNTNO      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '50'          WKBSJKKB                       奨励金条件区分    
     C                   MOVEL(P)  '10'          WKBSSPKB                       奨励金特殊条件区分
     C     WKKEYBT3      CHAIN     FBMBTL03                           80        奨励金条件明細    
     C                   IF        (*IN80 = *OFF)                               IF1                 
 D03 C***                IF        (ECKABTKB = '02')                            IF2                 
 D03 C***                MOVEL(P)  '01'          ECKABTKB                       型別区分          
 D03 C***                ENDIF                                                  END-IF2             
      *                                                                                             
     C                   ENDIF                                                  END-IF1             
YS2   *                                                                                             
      *-------------------------------------------                                                  
      *                                                                                             
     C                   LEAVE                                                  LEAVE-DO1           
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*対象条件チェック                                                                           
     C**********************************************************************                        
     C     #CHK10        BEGSR                                                                      
      *                                                                                             
      *初期化処理-------------------------------                                                  
      *対象外で初めて、対象があったら対象に変更                                                   
     C                   SETON                                        88                            
      *                                                                                             
      *ポインターセット-------------------------                                                  
     C                   MOVEL(P)  BSCLNTNO      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '10'          WKBSJKKB                       奨励金条件区分    
     C     WKKEYBT1      SETLL     FBMBTL01                                     奨励金条件明細    
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
     C     WKKEYBT1      READE     FBMBTL01                               91    奨励金条件明細    
     C   91              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
      *チェック処理-------------------                                                            
      *ルート---------------                                                                      
      *完全一致                                                                                   
     C                   IF        (%TRIM(BTRTCHKB) <> *BLANK)                  IF1                 
     C                   IF        (BTRTCHKB <> ECROUTKB)                       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *型別-----------------                                                                      
      *完全一致                                                                                   
     C                   IF        (%TRIM(BTKACHKB) <> *BLANK)                  IF1                 
     C                   IF        (BTKACHKB <> ECKABTKB)                       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *旧部署---------------                                                                      
      *先頭一致                                                                                   
     C                   IF        (%TRIM(BTOBCHCD) <> *BLANK)                  IF1                 
     C                   IF        (%SCAN(%TRIM(BTOBCHCD):ECOBSYCD) <> 1)       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *客先-----------------                                                                      
      *先頭一致                                                                                   
     C                   IF        (%TRIM(BTOKCHCD) <> *BLANK)                  IF1                 
     C                   IF        (%SCAN(%TRIM(BTOKCHCD):ECOKYKCD) <> 1)       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金条件名称区分---                                                                      
      *元請指定                                                                                   
      *部分一致                                                                                   
     C                   IF        (%TRIM(BTBSJNKB) = '10')                     IF1                 
     C                   IF        (%TRIM(BTBSJNNM) <> *BLANK)                  IF2                 
     C                   MOVEL(P)  BTBSJNNM      W3NAME01                       奨励金条件名称    
     C                   MOVEL(P)  ECMUBPNM      W3NAME02                       元請名（ＢＰ実績）
     C                   EXSR      #CTOS0100                                    漢字検索          
     C                   IF        (W31BOOL  = '0')                             IF3                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *ＳＡＰ品目コード                                                                           
     C                   IF        (%TRIM(BTBSJNKB) = '30')                     IF1                 
     C                   IF        (%TRIM(BTBSJNNM) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTBSJNNM):ECHINMCD) <> 1)       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *ＳＡＰ品目名称                                                                             
      *部分一致                                                                                   
     C                   IF        (%TRIM(BTBSJNKB) = '20')                     IF1                 
     C                   IF        (%TRIM(BTBSJNNM) <> *BLANK)                  IF2                 
     C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
     C                   MOVEL(P)  ECHINMCD      WKMATNR                        品目コード        
     C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
     C     WKKEYPC       CHAIN     FSSPCL01                           95        品目テキスト      
     C                   IF        (*IN95 = *OFF)                               IF3                 
     C                   MOVEL(P)  BTBSJNNM      W3NAME01                       奨励金条件名称    
     C                   MOVEL(P)  PCMAKTX       W3NAME02                       品目テキスト(SAP  
     C                   EXSR      #CTOS0100                                    漢字検索          
     C                   IF        (W31BOOL  = '0')                             IF4                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF4             
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *現場名称                                                                                   
      *部分一致                                                                                   
     C                   IF        (%TRIM(BTBSJNKB) = '40')                     IF1                 
     C                   IF        (%TRIM(BTBSJNNM) <> *BLANK)                  IF2                 
     C                   MOVEL(P)  BTBSJNNM      W3NAME01                       奨励金条件名称    
     C                   MOVEL(P)  ECGBBPNM      W3NAME02                       現場名            
     C                   EXSR      #CTOS0100                                    漢字検索          
     C                   IF        (W31BOOL  = '0')                             IF3                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *対象データ---------------------                                                            
     C                   SETOFF                                       88                            
     C                   LEAVE                                                                      
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*除外条件チェック                                                                           
     C**********************************************************************                        
     C     #CHK20        BEGSR                                                                      
      *                                                                                             
      *初期化処理-------------------------------                                                  
     C                   SETOFF                                       88                            
      *                                                                                             
      *ポインターセット-------------------------                                                  
     C                   MOVEL(P)  BSCLNTNO      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '20'          WKBSJKKB                       奨励金条件区分    
     C     WKKEYBT1      SETLL     FBMBTL01                                     奨励金条件明細    
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
     C     WKKEYBT1      READE     FBMBTL01                               91    奨励金条件明細    
     C   91              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
      *チェック処理-------------------                                                            
      *ルート---------------                                                                      
      *完全一致                                                                                   
     C                   IF        (%TRIM(BTRTCHKB) <> *BLANK)                  IF1                 
     C                   IF        (BTRTCHKB <> ECROUTKB)                       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *型別-----------------                                                                      
      *完全一致                                                                                   
     C                   IF        (%TRIM(BTKACHKB) <> *BLANK)                  IF1                 
     C                   IF        (BTKACHKB <> ECKABTKB)                       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *旧部署---------------                                                                      
      *先頭一致                                                                                   
     C                   IF        (%TRIM(BTOBCHCD) <> *BLANK)                  IF1                 
     C                   IF        (%SCAN(%TRIM(BTOBCHCD):ECOBSYCD) <> 1)       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *客先-----------------                                                                      
      *先頭一致                                                                                   
     C                   IF        (%TRIM(BTOKCHCD) <> *BLANK)                  IF1                 
     C                   IF        (%SCAN(%TRIM(BTOKCHCD):ECOKYKCD) <> 1)       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金条件名称区分---                                                                      
      *元請指定                                                                                   
      *部分一致                                                                                   
     C                   IF        (%TRIM(BTBSJNKB) = '10')                     IF1                 
     C                   IF        (%TRIM(BTBSJNNM) <> *BLANK)                  IF2                 
     C                   MOVEL(P)  BTBSJNNM      W3NAME01                       奨励金条件名称    
     C                   MOVEL(P)  ECMUBPNM      W3NAME02                       元請名（ＢＰ実績）
     C                   EXSR      #CTOS0100                                    漢字検索          
     C                   IF        (W31BOOL  = '0')                             IF3                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金条件名称区分---                                                                      
      *ＳＡＰ品目名称                                                                             
      *部分一致                                                                                   
     C                   IF        (%TRIM(BTBSJNKB) = '20')                     IF1                 
     C                   IF        (%TRIM(BTBSJNNM) <> *BLANK)                  IF2                 
     C                   MOVEL(P)  WDCLNTCD      WKMANDT                        クライアント      
     C                   MOVEL(P)  ECHINMCD      WKMATNR                        品目コード        
     C                   MOVEL(P)  'J'           WKSPRAS                        言語キー          
     C     WKKEYPC       CHAIN     FSSPCL01                           95        品目テキスト      
     C                   IF        (*IN95 = *OFF)                               IF3                 
     C                   MOVEL(P)  BTBSJNNM      W3NAME01                       奨励金条件名称    
     C                   MOVEL(P)  PCMAKTX       W3NAME02                       品目テキスト(SAP  
     C                   EXSR      #CTOS0100                                    漢字検索          
     C                   IF        (W31BOOL  = '0')                             IF4                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF4             
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金条件名称区分---                                                                      
      *ＳＡＰ品目コード                                                                           
     C                   IF        (%TRIM(BTBSJNKB) = '30')                     IF1                 
     C                   IF        (%TRIM(BTBSJNNM) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTBSJNNM):ECHINMCD) <> 1)       IF2                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *現場名称                                                                                   
      *部分一致                                                                                   
     C                   IF        (%TRIM(BTBSJNKB) = '40')                     IF1                 
     C                   IF        (%TRIM(BTBSJNNM) <> *BLANK)                  IF2                 
     C                   MOVEL(P)  BTBSJNNM      W3NAME01                       奨励金条件名称    
     C                   MOVEL(P)  ECGBBPNM      W3NAME02                       現場名            
     C                   EXSR      #CTOS0100                                    漢字検索          
     C                   IF        (W31BOOL  = '0')                             IF3                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *対象外データ-------------------                                                            
     C                   SETON                                        88                            
     C                   LEAVE                                                                      
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*集約条件チェック                                                                           
     C**********************************************************************                        
     C     #CHK30        BEGSR                                                                      
      *                                                                                             
      *初期化処理-------------------------------                                                  
      *                                                                                             
      *ポインターセット-------------------------                                                  
     C                   MOVEL(P)  BSCLNTNO      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   MOVEL(P)  BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '30'          WKBSJKKB                       奨励金条件区分    
     C     WKKEYBT1      SETLL     FBMBTL01                                     奨励金条件明細    
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
     C     WKKEYBT1      READE     FBMBTL01                               91    奨励金条件明細    
     C   91              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
     C                   SELECT                                                 SL1                 
      *部署別-------------------------                                                            
     C                   WHEN      (BSBSSHKB = '10')                            WHEN-SL1            
     C                   IF        (%TRIM(ECOBSYCD) <> *BLANK)                  IF1                 
      *                                                                                             
     C                   SETOFF                                       80                            
      *                                                                                             
      *旧部署01個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS01) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS01):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署02個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS02) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS02):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署03個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS03) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS03):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署04個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS04) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS04):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署05個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS05) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS05):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署06個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS06) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS06):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署07個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS07) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS07):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署08個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS08) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS08):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署09個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS09) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS09):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧部署10個別集約                                                                         
     C                   IF        (%TRIM(BTOBKS10) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOBKS10):ECOBSYCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *集約対象                                                                                   
     C                   IF        (*IN80 = *ON)                                IF2                 
     C                   IF        (%TRIM(BTEBKSCD) <> *BLANK)                  IF3                 
     C                   MOVEL(P)  BTEBKSCD      ECEGBUCD                       営業部            
     C                   ENDIF                                                  END-IF3             
     C                   MOVEL(P)  BTBSKSCD      WXBSGEC2                       汎用コード        
     C                   MOVEL(P)  BTBSKSNM      WXBSGEN2                       汎用名称          
     C                   LEAVE                                                  LEAVE-DO1           
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *客先別-------------------------                                                            
     C                   WHEN      (BSBSSHKB = '20')                            WHEN-SL1            
     C                   IF        (%TRIM(ECOKYKCD) <> *BLANK)                  IF1                 
      *                                                                                             
     C                   SETOFF                                       80                            
      *                                                                                             
      *旧客先01個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS01) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS01):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先02個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS02) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS02):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先03個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS03) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS03):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先04個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS04) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS04):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先05個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS05) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS05):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先06個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS06) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS06):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先07個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS07) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS07):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先08個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS08) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS08):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先09個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS09) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS09):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *旧客先10個別集約                                                                         
     C                   IF        (%TRIM(BTOKKS10) <> *BLANK)                  IF2                 
     C                   IF        (%SCAN(%TRIM(BTOKKS10):ECOKYKCD) = 1)        IF3                 
     C                   SETON                                        80                            
     C                   ENDIF                                                  END-IF3             
     C                   ENDIF                                                  END-IF2             
      *集約対象                                                                                   
     C                   IF        (*IN80 = *ON)                                IF2                 
     C                   IF        (%TRIM(BTEBKSCD) <> *BLANK)                  IF3                 
     C                   MOVEL(P)  BTEBKSCD      ECEGBUCD                       営業部            
     C                   ENDIF                                                  END-IF3             
     C                   MOVEL(P)  BTBSKSCD      WXBSGEC2                       汎用コード        
     C                   MOVEL(P)  BTBSKSNM      WXBSGEN2                       汎用名称          
     C                   LEAVE                                                  LEAVE-DO1           
     C                   ENDIF                                                  END-IF2             
     C                   ENDIF                                                  END-IF1             
     C                   ENDSL                                                  END-SL1             
      *---------------------------------                                                            
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*ワークファイル書き出し                                                                     
     C**********************************************************************                        
     C     #WRTTP10      BEGSR                                                                      
      *                                                                                             
      *ファイル読み込み-------------------------                                                  
     C                   Z-ADD     WXGTKSYM      WKGTKSYM                       月次更新年月      
     C                   MOVEL(P)  WXEGBUC2      WKEGBUCD                       営業部            
     C                   MOVEL(P)  WXBSGEC2      WKBSGECD                       汎用コード        
     C                   MOVEL(P)  ECKABTKB      WKKABTKB                       型別区分          
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　        
     C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
      *                                                                                             
     C   81              Z-ADD     WXGTKSYM      TPGTKSYM                       月次更新年月      
     C   81              MOVEL(P)  '10'          TPKISOKB                       階層区分　　      
     C                   MOVEL(P)  WXEGBUC2      TPEGBUCD                       営業部            
     C                   MOVEL(P)  WXEGBUN2      TPEGBUNM                       営業部名称        
     C   81              MOVEL(P)  WXBSGEC2      TPBSGECD                       汎用コード        
     C   81              MOVEL(P)  WXBSGEN2      TPBSGENM                       汎用名称　　      
     C                   MOVEL(P)  ECKABTKB      TPKABTKB                       型別区分          
     C                   MOVEL(P)  *BLANK        TPKABTNM                       型別名            
     C                   ADD       ECBPSKKG      TPBPSKKG                       ＢＰ仕切金額      
     C                   ADD       ECBPURKG      TPBPURKG                       ＢＰ売上金額      
     C                   Z-ADD     *ZERO         TPBSKART                       奨励金掛率        
     C                   Z-ADD     *ZERO         TPBPSRKG                       奨励金金額        
     C                   ADD       ECBPSKKG      TPBPSKKM                       ＢＰ仕切金額（元）
     C                   ADD       ECBPURKG      TPBPURKM                       ＢＰ売上金額（元）
     C                   Z-ADD     *ZERO         TPBPSRKM                       奨励金金額（元）  
     C                   MOVEL(P)  BSBSTNKB      TPBSTNKB                       奨励金算出単位    
     C                   MOVEL(P)  BSBSMRKB      TPBSMRKB                       奨励金丸め区分    
     C                   MOVEL(P)  BSBSMTKB      TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *型別名取得---------------------                                                            
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  TPKABTKB      WKKABTKB                       型別区分          
     C     WKKEYEF       CHAIN     FBMEFL02                           80                            
     C  N80              MOVEL(P)  EFKABTNM      TPKABTNM                       型別名            
      *                                                                                             
      *奨励金掛率取得-----------------                                                            
     C                   MOVEL(P)  WDCLNTCD      WKCLNTNO                       クライアント      
     C                   MOVEL(P)  BSBSTPKB      WKBSTPKB                       奨励金タイプ      
     C                   Z-ADD     BSFRMNDT      WKFRMNDT                       適用月度FROM      
     C                   MOVEL(P)  '40'          WKBSJKKB                       奨励金条件区分    
     C                   MOVEL(P)  TPKABTKB      WKKKRHKB                       型別　：掛率　    
     C     WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C   80              MOVEL(P)  *BLANK        WKKKRHKB                       型別　：掛率　    
     C   80WKKEYBT2      CHAIN     FBMBTL02                           80        奨励金条件明細    
     C  N80              Z-ADD     BTBSKART      TPBSKART                       奨励金掛率        
      *                                                                                             
     C                   EVAL      TPBPSRKG = TPBPURKG * TPBSKART / 100         奨励金金額        
     C                   Z-ADD     TPBPSRKG      TPBPSRKM                       奨励金金額元      
      *                                                                                             
      *丸め処理-----------------------                                                            
      *ＢＰ仕切金額                                                                               
     C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
      *ＢＰ売上金額                                                                               
     C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
      *奨励金金額                                                                                 
     C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
      *                                                                                             
      *更新-------------------------------------                                                  
     C   81              WRITE     OB6110R01                                    ワークファイル    
     C  N81              UPDATE    OB6110R01                                    ワークファイル    
      *                                                                                             
      *-------------------------------------------                                                  
      *                                                                                             
     C                   ENDSR                                                                      
      *                                                                                             
     C**********************************************************************                        
     C*ワークファイル書き出し（月別計）                                                           
     C**********************************************************************                        
     C     #WRTTP10M     BEGSR                                                                      
      *                                                                                             
      *ファイル読み込み-------------------------                                                  
     C                   Z-ADD     WXGTKSYMBF    WKGTKSYM                       月次更新年月      
     C                   MOVEL(P)  WXEGBUCDBF    WKEGBUCD                       営業部            
     C                   MOVEL(P)  WXBSGECDBF    WKBSGECD                       汎用コード        
     C                   MOVEL(P)  *BLANK        WKKABTKB                       型別区分          
     C                   MOVEL(P)  WXKISOKBBF    WKKISOKB                       階層区分　        
     C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
      *                                                                                             
     C   81              Z-ADD     WXGTKSYMBF    TPGTKSYM                       月次更新年月      
     C   81              MOVEL(P)  WXKISOKBBF    TPKISOKB                       階層区分　　      
     C   81              MOVEL(P)  WXEGBUCDBF    TPEGBUCD                       営業部            
     C   81              MOVEL(P)  WXEGBUNMBF    TPEGBUNM                       営業部名称        
     C   81              MOVEL(P)  WXBSGECDBF    TPBSGECD                       汎用コード        
     C   81              MOVEL(P)  WXBSGENMBF    TPBSGENM                       汎用名称　        
     C   81              MOVEL(P)  *BLANK        TPKABTKB                       型別区分          
     C   81              MOVEL(P)  '月別'      TPKABTNM                       型別名            
     C                   ADD       WXBPSKKGBF    TPBPSKKG                       ＢＰ仕切金額      
     C                   ADD       WXBPURKGBF    TPBPURKG                       ＢＰ売上金額      
     C                   Z-ADD     WXBSKARTBF    TPBSKART                       奨励金掛率        
     C                   ADD       WXBPSRKGBF    TPBPSRKG                       奨励金金額        
     C                   ADD       WXBPSKKMBF    TPBPSKKM                       ＢＰ仕切金額（元）
     C                   ADD       WXBPURKMBF    TPBPURKM                       ＢＰ売上金額（元）
     C                   ADD       WXBPSRKMBF    TPBPSRKM                       奨励金金額（元）  
     C                   MOVEL(P)  WXBSTNKBBF    TPBSTNKB                       奨励金算出単位    
     C                   MOVEL(P)  WXBSMRKBBF    TPBSMRKB                       奨励金丸め区分    
     C                   MOVEL(P)  WXBSMTKBBF    TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *丸め処理-----------------------                                                            
      *奨励金算出単位（型別）                                                                     
     C*****              IF        (TPBSTNKB = '10') OR                         IF1                 
     C*****                        (TPBSTNKB = '20')                                                
      *ＢＰ仕切金額                                                                               
     C*****              Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
     C*****              EXSR      #PROCMR                                                          
     C*****              Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
      *ＢＰ売上金額                                                                               
     C*****              Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
     C*****              EXSR      #PROCMR                                                          
     C*****              Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
      *奨励金金額                                                                                 
     C*****              Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
     C*****              EXSR      #PROCMR                                                          
     C*****              Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
     C*****              ENDIF                                                  END-IF1             
      *                                                                                             
      *更新-------------------------------------                                                  
     C   81              WRITE     OB6110R01                                    ワークファイル    
     C  N81              UPDATE    OB6110R01                                    ワークファイル    
      *                                                                                             
      *-------------------------------------------                                                  
      *                                                                                             
      *                                                                                             
     C                   ENDSR                                                                      
      *                                                                                             
     C**********************************************************************                        
     C*ワークファイル書き出し（営業所計）                                                         
     C**********************************************************************                        
     C     #WRTTP20      BEGSR                                                                      
      *                                                                                             
      *ファイル読み込み-------------------------                                                  
     C                   Z-ADD     WXGTKSYMBF    WKGTKSYM                       月次更新年月      
     C                   MOVEL(P)  WXEGBUCDBF    WKEGBUCD                       営業部            
     C                   MOVEL(P)  *ALL'9'       WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKBBF    WKKABTKB                       型別区分          
     C                   MOVEL(P)  '20'          WKKISOKB                       階層区分　        
     C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
      *                                                                                             
     C   81              Z-ADD     WXGTKSYMBF    TPGTKSYM                       月次更新年月      
     C   81              MOVEL(P)  '20'          TPKISOKB                       階層区分　　      
     C                   MOVEL(P)  WXEGBUCDBF    TPEGBUCD                       営業部            
     C                   MOVEL(P)  WXEGBUNMBF    TPEGBUNM                       営業部名称        
     C                   MOVEL(P)  *ALL'9'       TPBSGECD                       汎用コード        
     C                   MOVEL(P)  *BLANK        TPBSGENM                       汎用名称          
     C                   MOVEL(P)  WXKABTKBBF    TPKABTKB                       型別区分          
     C                   MOVEL(P)  WXKABTNMBF    TPKABTNM                       型別名            
     C                   ADD       WXBPSKKGBF    TPBPSKKG                       ＢＰ仕切金額      
     C                   ADD       WXBPURKGBF    TPBPURKG                       ＢＰ売上金額      
     C                   Z-ADD     WXBSKARTBF    TPBSKART                       奨励金掛率        
     C                   ADD       WXBPSRKGBF    TPBPSRKG                       奨励金金額        
     C                   ADD       WXBPSKKMBF    TPBPSKKM                       ＢＰ仕切金額（元）
     C                   ADD       WXBPURKMBF    TPBPURKM                       ＢＰ売上金額（元）
     C                   ADD       WXBPSRKMBF    TPBPSRKM                       奨励金金額（元）  
     C                   MOVEL(P)  WXBSTNKBBF    TPBSTNKB                       奨励金算出単位    
     C                   MOVEL(P)  WXBSMRKBBF    TPBSMRKB                       奨励金丸め区分    
     C                   MOVEL(P)  WXBSMTKBBF    TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *丸め処理-----------------------                                                            
      *奨励金算出単位（型別）                                                                     
     C                   IF        (TPBSTNKB = '10') OR                         IF1                 
     C                             (TPBSTNKB = '20')                            IF1                 
      *ＢＰ仕切金額                                                                               
     C                   Z-ADD     TPBPSKKM      WXBSMRSR                       ＢＰ仕切金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSKKG                       ＢＰ仕切金額      
      *ＢＰ売上金額                                                                               
     C                   Z-ADD     TPBPURKM      WXBSMRSR                       ＢＰ売上金額（元）
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPURKG                       ＢＰ売上金額      
      *奨励金金額                                                                                 
     C                   Z-ADD     TPBPSRKM      WXBSMRSR                       奨励金金額（元）  
     C                   EXSR      #PROCMR                                                          
     C                   Z-ADD     WXBSMRSR      TPBPSRKG                       奨励金金額        
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *更新-------------------------------------                                                  
     C   81              WRITE     OB6110R01                                    ワークファイル    
     C  N81              UPDATE    OB6110R01                                    ワークファイル    
      *                                                                                             
      *-------------------------------------------                                                  
      *                                                                                             
     C                   ENDSR                                                                      
      *                                                                                             
     C**********************************************************************                        
     C*ワークファイル書き出し（総合計）                                                           
     C**********************************************************************                        
     C     #WRTTP30      BEGSR                                                                      
      *                                                                                             
      *ファイル読み込み-------------------------                                                  
     C                   Z-ADD     WXGTKSYMBF    WKGTKSYM                       月次更新年月      
     C                   MOVEL(P)  *ALL'9'       WKEGBUCD                       営業部            
     C                   MOVEL(P)  *ALL'9'       WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKBBF    WKKABTKB                       型別区分          
     C                   MOVEL(P)  '30'          WKKISOKB                       階層区分　        
     C     WKKEYTP1      CHAIN     OB6110L01                          81        ワークファイル    
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C   81              CLEAR     *ALL          OB6110R01                      ワークファイル    
      *                                                                                             
     C   81              Z-ADD     WKGTKSYM      TPGTKSYM                       月次更新年月      
     C   81              MOVEL(P)  WKKISOKB      TPKISOKB                       階層区分　　      
     C   81              MOVEL(P)  WKEGBUCD      TPEGBUCD                       営業部            
     C   81              MOVEL(P)  '総合計'    TPEGBUNM                       営業部名称        
     C   81              MOVEL(P)  WKBSGECD      TPBSGECD                       汎用コード        
     C   81              MOVEL(P)  *BLANK        TPBSGENM                       汎用名称　        
     C                   MOVEL(P)  WXKABTKBBF    TPKABTKB                       型別区分          
     C                   MOVEL(P)  WXKABTNMBF    TPKABTNM                       型別名            
     C                   ADD       WXBPSKKGBF    TPBPSKKG                       ＢＰ仕切金額      
     C                   ADD       WXBPURKGBF    TPBPURKG                       ＢＰ売上金額      
     C                   Z-ADD     WXBSKARTBF    TPBSKART                       奨励金掛率        
     C                   ADD       WXBPSRKGBF    TPBPSRKG                       奨励金金額        
     C                   ADD       WXBPSKKMBF    TPBPSKKM                       ＢＰ仕切金額（元）
     C                   ADD       WXBPURKMBF    TPBPURKM                       ＢＰ売上金額（元）
     C                   ADD       WXBPSRKMBF    TPBPSRKM                       奨励金金額（元）  
     C                   MOVEL(P)  WXBSTNKBBF    TPBSTNKB                       奨励金算出単位    
     C                   MOVEL(P)  WXBSMRKBBF    TPBSMRKB                       奨励金丸め区分    
     C                   MOVEL(P)  WXBSMTKBBF    TPBSMTKB                       奨励金丸め単位    
      *                                                                                             
      *更新-------------------------------------                                                  
     C   81              WRITE     OB6110R01                                    ワークファイル    
     C  N81              UPDATE    OB6110R01                                    ワークファイル    
      *                                                                                             
      *-------------------------------------------                                                  
      *                                                                                             
     C                   ENDSR                                                                      
      *                                                                                             
     C**********************************************************************                        
     C*ワークファイル書き出し（部署空データ）                                                     
     C**********************************************************************                        
     C     #WRTTPBS      BEGSR                                                                      
      *                                                                                             
      *パラメータセット-------------------------                                                  
     C                   CLEAR     *ALL          OB6110R01                     ＷＫファイル       
      *                                                                                             
     C                   Z-ADD     WXCYM         TPGTKSYM                      月次更新年月       
     C                   MOVEL(P)  '10'          TPKISOKB                      階層区分　　       
     C                   MOVEL(P)  WXEGBUCD(IX4) TPEGBUCD                      営業部             
     C                   MOVEL(P)  WXEGBUNM(IX4) TPEGBUNM                      営業部名称         
     C                   MOVEL(P)  WXBSGECD(IX4) TPBSGECD                      汎用コード         
     C                   MOVEL(P)  WXBSGENM(IX4) TPBSGENM                      汎用名称　         
     C                   MOVEL(P)  WXKABTKB(IX5) TPKABTKB                      型別区分           
     C                   MOVEL(P)  WXKABTNM(IX5) TPKABTNM                      型別名             
     C                   Z-ADD     *ZERO         TPBPSKKG                      ＢＰ仕切金額       
     C                   Z-ADD     *ZERO         TPBPURKG                      ＢＰ売上金額       
     C                   Z-ADD     *ZERO         TPBSKART                      奨励金掛率         
     C                   Z-ADD     *ZERO         TPBPSRKG                      奨励金金額         
     C                   Z-ADD     *ZERO         TPBPSKKM                      ＢＰ仕切金額（元） 
     C                   Z-ADD     *ZERO         TPBPURKM                      ＢＰ売上金額（元） 
     C                   Z-ADD     *ZERO         TPBPSRKM                      奨励金金額（元）   
     C                   MOVEL(P)  *BLANK        TPBSTNKB                      奨励金算出単位     
     C                   MOVEL(P)  *BLANK        TPBSMRKB                      奨励金丸め区分     
     C                   MOVEL(P)  *BLANK        TPBSMTKB                      奨励金丸め単位     
      *                                                                                             
      *書き出し---------------------------------                                                  
     C                   WRITE     OB6110R01                                   ＷＫファイル       
      *                                                                                             
      *-------------------------------------------                                                  
      *                                                                                             
     C                   ENDSR                                                                      
      *                                                                                             
     C**********************************************************************                        
     C*小計データ作成                                                                             
     C**********************************************************************                        
     C     #PROCSK       BEGSR                                                                      
      *                                                                                             
      *ポインターセット-------------------------                                                  
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP0      SETLL     OB6110B00                                    ＷＫファイル      
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
      *ファイル読み込み---------------                                                            
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP0      READE     OB6110B00                              90    ＷＫファイル      
     C   90              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
      *パラメータ保存-----------------                                                            
     C                   MOVEL(P)  TPGTKSYM      WXGTKSYMBF                     月次更新年月BK    
     C                   MOVEL(P)  TPKISOKB      WXKISOKBBF                     階層区分　　BK    
     C                   MOVEL(P)  TPEGBUCD      WXEGBUCDBF                     営業部      BK    
     C                   MOVEL(P)  TPEGBUNM      WXEGBUNMBF                     営業部名称  BK    
     C                   MOVEL(P)  TPBSGECD      WXBSGECDBF                     汎用コード  BK    
     C                   MOVEL(P)  TPBSGENM      WXBSGENMBF                     汎用名称　  BK    
     C                   MOVEL(P)  TPKABTKB      WXKABTKBBF                     型別区分    BK    
     C                   MOVEL(P)  TPKABTNM      WXKABTNMBF                     型別名      BK    
     C                   Z-ADD     TPBPSKKG      WXBPSKKGBF                     ＢＰ仕切金額BK    
     C                   Z-ADD     TPBPURKG      WXBPURKGBF                     ＢＰ売上金額BK    
     C                   Z-ADD     TPBSKART      WXBSKARTBF                     奨励金掛率  BK    
     C                   Z-ADD     TPBPSRKG      WXBPSRKGBF                     奨励金金額  BK    
     C                   Z-ADD     TPBPSKKM      WXBPSKKMBF                     ＢＰ仕切金元BK    
     C                   Z-ADD     TPBPURKM      WXBPURKMBF                     ＢＰ売上金元BK    
     C                   Z-ADD     TPBPSRKM      WXBPSRKMBF                     奨励金金元  BK    
     C                   MOVEL(P)  TPBSTNKB      WXBSTNKBBF                     算出単位    BK    
     C                   MOVEL(P)  TPBSMRKB      WXBSMRKBBF                     丸め区分    BK    
     C                   MOVEL(P)  TPBSMTKB      WXBSMTKBBF                     丸め単位    BK    
      *                                                                                             
      *ワークファイル書き出し（営業所計）                                                         
     C                   EXSR      #WRTTP20                                                         
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*総合計データ作成                                                                           
     C**********************************************************************                        
     C     #PROCGK       BEGSR                                                                      
      *                                                                                             
      *ポインターセット-------------------------                                                  
     C                   MOVEL(P)  '20'          WKKISOKB                       階層区分　　      
     C     WKKEYTP0      SETLL     OB6110B00                                    ＷＫファイル      
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
      *ファイル読み込み---------------                                                            
     C                   MOVEL(P)  '20'          WKKISOKB                       階層区分　　      
     C     WKKEYTP0      READE     OB6110B00                              90    ＷＫファイル      
     C   90              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
      *パラメータ保存-----------------                                                            
     C                   MOVEL(P)  TPGTKSYM      WXGTKSYMBF                     月次更新年月BK    
     C                   MOVEL(P)  TPKISOKB      WXKISOKBBF                     階層区分　　BK    
     C                   MOVEL(P)  TPEGBUCD      WXEGBUCDBF                     営業部      BK    
     C                   MOVEL(P)  TPEGBUNM      WXEGBUNMBF                     営業部名称  BK    
     C                   MOVEL(P)  TPBSGECD      WXBSGECDBF                     汎用コード  BK    
     C                   MOVEL(P)  TPBSGENM      WXBSGENMBF                     汎用名称　  BK    
     C                   MOVEL(P)  TPKABTKB      WXKABTKBBF                     型別区分    BK    
     C                   MOVEL(P)  TPKABTNM      WXKABTNMBF                     型別名      BK    
     C                   Z-ADD     TPBPSKKG      WXBPSKKGBF                     ＢＰ仕切金額BK    
     C                   Z-ADD     TPBPURKG      WXBPURKGBF                     ＢＰ売上金額BK    
     C                   Z-ADD     TPBSKART      WXBSKARTBF                     奨励金掛率  BK    
     C                   Z-ADD     TPBPSRKG      WXBPSRKGBF                     奨励金金額  BK    
     C                   Z-ADD     TPBPSKKM      WXBPSKKMBF                     ＢＰ仕切金元BK    
     C                   Z-ADD     TPBPURKM      WXBPURKMBF                     ＢＰ売上金元BK    
     C                   Z-ADD     TPBPSRKM      WXBPSRKMBF                     奨励金金元  BK    
     C                   MOVEL(P)  TPBSTNKB      WXBSTNKBBF                     算出単位    BK    
     C                   MOVEL(P)  TPBSMRKB      WXBSMRKBBF                     丸め区分    BK    
     C                   MOVEL(P)  TPBSMTKB      WXBSMTKBBF                     丸め単位    BK    
      *                                                                                             
      *ワークファイル書き出し（総合計）                                                           
     C                   EXSR      #WRTTP30                                                         
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*月別計データ作成                                                                           
     C**********************************************************************                        
     C     #PROCDM       BEGSR                                                                      
      *                                                                                             
      *ポインターセット-------------------------                                                  
     C     *LOVAL        SETLL     OB6110B00                                    ＷＫファイル      
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
      *ファイル読み込み---------------                                                            
     C                   READ      OB6110B00                              90    ＷＫファイル      
     C   90              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
      *月別データは除外                                                                           
     C                   IF        (%TRIM(TPKABTKB) = *BLANK)                   IF1                 
     C                   ITER                                                   ITER-DO1            
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *パラメータ保存-----------------                                                            
     C                   MOVEL(P)  TPGTKSYM      WXGTKSYMBF                     月次更新年月BK    
     C                   MOVEL(P)  TPKISOKB      WXKISOKBBF                     階層区分　　BK    
     C                   MOVEL(P)  TPEGBUCD      WXEGBUCDBF                     営業部      BK    
     C                   MOVEL(P)  TPEGBUNM      WXEGBUNMBF                     営業部名称  BK    
     C                   MOVEL(P)  TPBSGECD      WXBSGECDBF                     汎用コード  BK    
     C                   MOVEL(P)  TPBSGENM      WXBSGENMBF                     汎用名称　  BK    
     C                   MOVEL(P)  TPKABTKB      WXKABTKBBF                     型別区分    BK    
     C                   MOVEL(P)  TPKABTNM      WXKABTNMBF                     型別名      BK    
     C                   Z-ADD     TPBPSKKG      WXBPSKKGBF                     ＢＰ仕切金額BK    
     C                   Z-ADD     TPBPURKG      WXBPURKGBF                     ＢＰ売上金額BK    
     C                   Z-ADD     TPBSKART      WXBSKARTBF                     奨励金掛率  BK    
     C                   Z-ADD     TPBPSRKG      WXBPSRKGBF                     奨励金金額  BK    
     C                   Z-ADD     TPBPSKKM      WXBPSKKMBF                     ＢＰ仕切金元BK    
     C                   Z-ADD     TPBPURKM      WXBPURKMBF                     ＢＰ売上金元BK    
     C                   Z-ADD     TPBPSRKM      WXBPSRKMBF                     奨励金金元  BK    
     C                   MOVEL(P)  TPBSTNKB      WXBSTNKBBF                     算出単位    BK    
     C                   MOVEL(P)  TPBSMRKB      WXBSMRKBBF                     丸め区分    BK    
     C                   MOVEL(P)  TPBSMTKB      WXBSMTKBBF                     丸め単位    BK    
      *                                                                                             
      *ワークファイル書き出し（月別計）                                                           
     C                   EXSR      #WRTTP10M                                                        
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*明細空データ作成                                                                           
     C**********************************************************************                        
     C     #PROCAD       BEGSR                                                                      
      *                                                                                             
      *汎用コード一覧取得-----------------------                                                  
     C                   EXSR      #GETBSGE                                                         
      *                                                                                             
      *初期値セット-----------------------------                                                  
     C                   Z-ADD     WIFRMNDT      WXCYM                          適用月度FROM      
     C                   Z-ADD     1             WXDD                           日                
      *年月ループ===============================                                                  
     C                   DO        *HIVAL                                       DO1                 
      *                                                                                             
      *汎用ループ=====================                                                            
     C     1             DO        WXBSGESR      IX4                            DO2                 
      *                                                                                             
      *型ループ=============                                                                      
     C     1             DO        WXKABTSR      IX5                            DO3                 
      *                                                                                             
      *データ存在チェック                                                                         
     C                   Z-ADD     WXCYM         WKGTKSYM                       月次更新年月      
     C                   MOVEL(P)  WXEGBUCD(IX4) WKEGBUCD                       営業部            
     C                   MOVEL(P)  WXBSGECD(IX4) WKBSGECD                       汎用コード        
     C                   MOVEL(P)  WXKABTKB(IX5) WKKABTKB                       型別区分          
     C                   MOVEL(P)  '10'          WKKISOKB                       階層区分　　      
     C     WKKEYTP1      CHAIN(N)  OB6110L01                          80        ＷＫファイル      
     C  N80              ITER                                                                       
      *                                                                                             
      *無かったら空データ書き出し                                                                 
     C                   EXSR      #WRTTPBS                                     部署空データ      
      *                                                                                             
     C                   ENDDO                                                  END-DO3             
      *=======================                                                                      
      *                                                                                             
     C                   ENDDO                                                  END-DO2             
      *=================================                                                            
      *                                                                                             
      *日付加算-----------------------                                                            
     C                   MOVE      WXDATE        WXDATED                                            
     C                   ADDDUR    1:*M          WXDATED                                            
     C                   MOVE      WXDATED       WXDATE                                             
      *                                                                                             
     C                   IF        (WXENDDT <= WXDATE)                          IF1                 
     C                   LEAVE                                                  LEAVE-DO1           
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*型一覧取得                                                                                 
     C**********************************************************************                        
     C     #GETKABT      BEGSR                                                                      
      *                                                                                             
      *初期化処理-------------------------------                                                  
     C                   Z-ADD     *ZERO         WXKABTSR                       型別区分数量      
     C                   Z-ADD     *ZERO         IX1                            指標              
      *                                                                                             
      *ポインターセット-------------------------                                                  
     C     *LOVAL        SETLL     OB6110L03                                    ＷＫファイル      
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
     C                   READ      OB6110L03                              90    ＷＫファイル      
     C   90              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
      *値保存-------------------------                                                            
     C                   ADD       1             WXKABTSR                       型別区分数量      
     C                   ADD       1             IX1                            指標              
     C                   MOVEL(P)  TPKABTKB      WXKABTKB(IX1)                  型別区分          
     C                   MOVEL(P)  TPKABTNM      WXKABTNM(IX1)                  型別名            
      *                                                                                             
      *ポインター再セット-------------                                                            
     C                   MOVEL(P)  TPKABTKB      WKKABTKB                       型別区分          
     C     WKKEYTP3      SETGT     OB6110L03                                    ＷＫファイル      
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*汎用コード一覧取得                                                                         
     C**********************************************************************                        
     C     #GETBSGE      BEGSR                                                                      
      *                                                                                             
      *初期化処理-------------------------------                                                  
     C                   Z-ADD     *ZERO         WXBSGESR                       汎用数量          
     C                   Z-ADD     *ZERO         IX2                            指標              
      *                                                                                             
      *ポインターセット-------------------------                                                  
     C     *LOVAL        SETLL     OB6110L02                                    ＷＫファイル      
      *                                                                                             
      *===========================================                                                  
     C                   DO        *HIVAL                                       DO1                 
     C                   READ      OB6110L02                              90    ＷＫファイル      
     C   90              LEAVE                                                  LEAVE-DO1           
      *                                                                                             
      *値保存-------------------------                                                            
     C                   ADD       1             WXBSGESR                       汎用数量          
     C                   ADD       1             IX2                            指標              
     C                   MOVEL(P)  TPBSGECD      WXBSGECD(IX2)                  汎用コード        
     C                   MOVEL(P)  TPBSGENM      WXBSGENM(IX2)                  汎用名称          
     C                   MOVEL(P)  TPEGBUCD      WXEGBUCD(IX2)                  営業部            
     C                   MOVEL(P)  TPEGBUNM      WXEGBUNM(IX2)                  営業部名称        
      *                                                                                             
      *ポインター再セット-------------                                                            
     C                   MOVEL(P)  TPBSGECD      WKBSGECD                       汎用コード        
     C                   MOVEL(P)  TPEGBUCD      WKEGBUCD                       営業部            
     C     WKKEYTP2      SETGT     OB6110L02                                    ＷＫファイル      
      *                                                                                             
     C                   ENDDO                                                  END-DO1             
      *===========================================                                                  
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*丸め処理                                                                                   
     C**********************************************************************                        
     C     #PROCMR       BEGSR                                                                      
      *                                                                                             
     C                   IF        (WXBSMRSR = *ZERO)                           IF1                 
     C                   LEAVESR                                                                    
     C                   ENDIF                                                  END-IF1             
      *                                                                                             
      *奨励金丸め単位-----------------                                                            
     C                   Z-ADD     1             WXMTKBSR                       丸め単位数量      
     C                   SELECT                                                 SL1                 
      *整数-----------------                                                                      
     C                   WHEN      (TPBSMTKB = '10')                            WHEN-SL1            
     C                   Z-ADD     1             WXMTKBSR                       丸め単位数量      
      * 10円----------------                                                                      
     C                   WHEN      (TPBSMTKB = '20')                            WHEN-SL1            
     C                   Z-ADD     10            WXMTKBSR                       丸め単位数量      
      * 100円---------------                                                                      
     C                   WHEN      (TPBSMTKB = '30')                            WHEN-SL1            
     C                   Z-ADD     100           WXMTKBSR                       丸め単位数量      
      * 1000円--------------                                                                      
     C                   WHEN      (TPBSMTKB = '40')                            WHEN-SL1            
     C                   Z-ADD     1000          WXMTKBSR                       丸め単位数量      
     C                   ENDSL                                                  END-SL1             
      *                                                                                             
      *丸め区分-----------------------                                                            
     C                   EVAL      WXBSMRSR = WXBSMRSR / WXMTKBSR                                   
      *                                                                                             
     C                   SELECT                                                 SL1                 
      *切り上げ-------------                                                                      
     C                   WHEN      (TPBSMRKB = '10')                            WHEN-SL1            
     C                   IF        (WXBSMRSR >= *ZERO)                          IF1                 
     C                   EVAL      WXBSMRSR = %INT(WXBSMRSR + 0.999999999)      ＋                
     C                   ELSE                                                   ELSE-IF1            
     C                   EVAL      WXBSMRSR = %INT(WXBSMRSR - 0.999999999)      －                
     C                   ENDIF                                                  END-IF1             
      *切り捨て-------------                                                                      
     C                   WHEN      (TPBSMRKB = '20')                            WHEN-SL1            
     C                   EVAL      WXBSMRSR = %INT(WXBSMRSR)                                        
      *四捨五入-------------                                                                      
     C                   WHEN      (TPBSMRKB = '30')                            WHEN-SL1            
     C                   EVAL      WXBSMRSR = %INTH(WXBSMRSR)                                       
     C                   ENDSL                                                  END-SL1             
      *                                                                                             
     C                   EVAL      WXBSMRSR = WXBSMRSR * WXMTKBSR                                   
      *                                                                                             
      *-------------------------------------------                                                  
      *                                                                                             
     C                   ENDSR                                                                      
      *                                                                                             
     C**********************************************************************                        
     C*出力バラメータ設定                                                                         
     C**********************************************************************                        
     C     #SETPRM       BEGSR                                                                      
      *                                                                                             
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*漢字項目検索サブルーチン(CALL OS0100SR)                                                    
     C**********************************************************************                        
     C     #CTOS0100     BEGSR                                                                      
     C*                                                                                             
     C*漢字項目検索                                                                               
     C                   CLEAR                   WOPARM0100                                         
     C*                                                                                             
     C                   CALL      'OS0100SR'                           99                          
     C                   PARM                    WIPARM0100                                         
     C                   PARM                    WOPARM0100                                         
     C*                                                                                             
     C   99              MOVEL(P)  '0'           W31BOOL                                            
     C*                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*応答パラメータチェック                                                                     
     C**********************************************************************                        
     C     #CHKOPRM      BEGSR                                                                      
      *                                                                                             
     C                   ENDSR                                                                      
     C**********************************************************************                        
     C*終了処理                                                                                   
     C**********************************************************************                        
     C     #END          BEGSR                                                                      
      *                                                                                             
      *終結処理判定                                                                               
     C                   IF        (WISYORKB = '3') OR                                              
     C                             (WOKEIZFG = '0') OR                                              
     C                             (*IN89 = *ON)                                                    
     C                   SETON                                        LR                            
     C                   ENDIF                                                                      
      *                                                                                             
     C                   RETURN                                                                     
      *                                                                                             
     C                   ENDSR                                                                      
     C*********************************************************************                         
