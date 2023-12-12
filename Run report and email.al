  PROPERTIES
  {
    TableNo=472;
    OnRun=VAR
            SomeReport@1000000000 : Report 50028;
                                        FileName@1000000001 : Text;
                                        RepOStream@1000000003 : OutStream;
                                        RepIStream@1000000004 : InStream;
                                        TempBlob@1000000002 : Record 99008535;
                                        SMTPMail@1000000005 : Codeunit 400;
                                        SMTPMailSetup@1000000006 : Record 409;
          BEGIN
            // Split Param string
            IF Rec."Parameter String" <> '' THEN
              SplitParamString(Rec."Parameter String", SplitValues);
            //SplitParamString('silviuvirlan@yahoo.com;SomeItem;SomeLot;SomeLoco;SomeBin;SomeZone', SplitValues);
            SendTo := SplitValues.GetValue(0);
            Filter1 := SplitValues.GetValue(1);
            Filter2 := SplitValues.GetValue(2);
            Filter3 := SplitValues.GetValue(3);
            Filter4 :=SplitValues.GetValue(4);
            Filter5 := SplitValues.GetValue(5);

            // Run report
            SomeReport.SetParams(Filter1,Filter2,Filter3,Filter4,Filter5);
            SomeReport.USEREQUESTPAGE := FALSE;
            TempBlob.Blob.CREATEOUTSTREAM(RepOStream);
            SomeReport.SAVEAS('',REPORTFORMAT::Pdf,RepOStream);
            TempBlob.Blob.CREATEINSTREAM(RepIStream);
            FileName := STRSUBSTNO('Some report caption - %1.pdf',FORMAT(TODAY()));

            // Email
            SMTPMailSetup.GET;
            CLEAR(SMTPMail);
            SMTPMail.CreateMessage('',SMTPMailSetup."User ID",SendTo,'SomeReport caption','',TRUE);
            SMTPMail.AddAttachmentStream(RepIStream,FileName);
            SMTPMail.Send;
          END;

  }
  CODE
  {
    VAR
      Filter1@1000000000 : Text;
      Filter2@1000000001 : Text;
      Filter3@1000000002 : Text;
      Filter4@1000000003 : Text;
      Filter5@1000000004 : Text;
      SplitValues@1000000005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
                                   SendTo@1000000006 : Text;
                                   TempBlob@1000000007 : Record 99008535;

    LOCAL PROCEDURE SplitParamString@1000000000(Input@1000000000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String"; VAR SplitValues@1000000001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array");
    VAR
        Separator@1000000002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
        i@1000000003 : Integer;
    BEGIN
        Separator := ';';
        SplitValues := Input.Split(Separator.ToCharArray());
    END;