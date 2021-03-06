#include "PROTHEUS.ch"

User Function tReport_SQL()

Local oReport

	//Criando o grupo de pergunta
	CriaPerg()
	
	//Carregando os dados da pergunta
	Pergunte("XCLIVEND",.F.)
	CriaPerg()
	
	//Chando a Fun��o para criar a estrutura do relatorio	
	oReport := ReportDef()
  
  //Imprimindo o Relatorio
	oReport:PrintDialog()
      

Return( Nil )
//***********************************************************************************************************************************

Static Function ReportDef()

Local oReport
Local oSection
Local oBreak

// Criando a o Objeto

oReport := TReport():New("ClinteXVendedor","Relatorio de Clientes X Vendedor","XCLIVEND",{|oReport| PrintReport(oReport)},"Relatorio de visitas de vendedores nos clientes")

oSection := TRSection():New(oReport,"Dados dos Clientes",{"SA1"} ) /* Defini��o da cria��o de uma se��o */

	TRCell():New(oSection,"A1_EST"    , "SA1")
	TRCell():New(oSection,"A1_COD"    ," SA1","Cliente") /* Aqui � definido um cabe�alho diferente para A1_COD*/
	TRCell():New(oSection,"A1_LOJA"   , "SA1")
	TRCell():New(oSection,"A1_NOME"   , "SA1")
	TRCell():New(oSection,"A1_END"    , "SA1")
	TRCell():New(oSection,"A1_CEP"    , "SA1")
	TRCell():New(oSection,"A1_CONTATO", "SA1")
	TRCell():New(oSection,"A1_TEL"    , "SA1")

// Quebra por Vendedor
oBreak := TRBreak():New(oSection,oSection:Cell("A1_EST"),"Sub Total Vendedores")     
//Fazendo a contagem por codigo
 TRFunction():New(oSection:Cell("A1_COD"   ), NIL, "COUNT", oBreak)


Return ( oReport )

//*******************************************************************************************

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cPart := ""



oSection:BeginQuery()


If (MV_PAR01) .AND. (MV_PAR02)
	cPart := "% AND A1_COD >= '" + MV_PAR01 + "' "
	cPart += "  AND A1_COD <= '" + MV_PAR02 + "' %"
Else
  cPart := "%%"
EndIf


  
BeginSql alias "QRYSA1"

	SELECT A1_COD,A1_LOJA,A1_NOME,A1_VEND,A1_ULTVIS,A1_TEMVIS,A1_TEL,A1_CONTATO,A1_EST	
	FROM %table:SA1% SA1
	WHERE A1_FILIAL = %xfilial:SA1% 
	AND A1_MSBLQL <> '1' 
	AND SA1.%notDel% 
	
	%exp:cPart%
	
	ORDER BY A1_EST
	
EndSql

aRetSql := GetLastQuery()

memowrite("C:\sql.txt",aRetSql[2])

oSection:EndQuery()


oSection:Print()

Return( Nil )

//=====================================================================================================================


Static Function CriaPerg()

cPerg:= "XCLIVEND"


//Cria��o de pergunta no arquivo SX1
//PutSX1(cGrupo,cOrdem,cPergunt,cPergSpa,cPergEng,cVar,cTipo,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3,cGrpSXG, [ cPyme], < cVar01>, [ cDef01], [ cDefSpa1], [ cDefEng1], [ cCnt01], [ cDef02], [ cDefSpa2], [ cDefEng2], [ cDef03], [ cDefSpa3], [ cDefEng3], [ cDef04], [ cDefSpa4], [ cDefEng4], [ cDef05], [ cDefSpa5], [ cDefEng5], [ aHelpPor], [ aHelpEng], [ aHelpSpa], [ cHelp] )
PutSx1( cPerg,"01","Cliente de"			,"","","mv_ch1","C",6,0,0,"C","","SA1","","","MV_PAR01","","","","","","","","","","","","","","","","",{""},{""},{""},"")
PutSx1( cPerg,"02","Cliente ate"			,"","","mv_ch2","C",6,0,0,"C","","SA1","","","MV_PAR02","","","","","","","","","","","","","","","","",{""},{""},{""},"")

Return()



