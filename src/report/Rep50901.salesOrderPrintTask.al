report 50901 salesOrderPrintTask
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './salesOrderReceiptPrintTask.rdl';
    Caption = 'Sales Order Print_KSS';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            column(Order_Confirmation; "No.") { }
            column(Order_Date; "Order Date") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Tax_Area_Code; "Tax Area Code") { }
            column(Bill_to_Post_Code; "Bill-to Post Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(Quote_No_; "Quote No.") { }
            column(Shipment_Method; "Shipment Method Code") { }
            column(Invoice_Discount_Amount; "Invoice Discount Amount") { }
            column(countryRegionName; countryRegionName) { }
            column(companyName; companyArray[1]) { }
            column(companyAdd1; companyArray[2]) { }
            column(companyAdd2; companyArray[3]) { }
            column(companyAdd3; companyArray[4]) { }
            column(companyShipToCountry; companyArray[5]) { }
            column(companyPicture; companyInfo.Picture) { }
            column(BankName; companyArray[5]) { }
            column(Bank_Branch_No; companyArray[6]) { }
            column(Bank_Account_No; companyArray[7]) { }
            column(IBAN; companyArray[8]) { }
            column(Swift_Code; companyArray[9]) { }
            column(Giro_No; companyArray[10]) { }
            // column(Home_Page; companyArray[11]) { }
            column(Phone_No; companyArray[11]) { }
            column(E_Mail; companyArray[12]) { }

            column(salesPersonName; salesPersonName) { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No."), "Document Type" = field("Document Type");
                column(ItemNo; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure; "Unit of Measure") { }
                column(Unit_Price_Excl_Tax; "Unit Price") { }
                column(Tax; "VAT %") { }
                column(Line_Amount_Excl_tax; "Line Amount") { }
            }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                if orderNo <> '' then begin
                    "Sales Header".SetRange("No.", orderNo);
                end
                else
                    Error('Give Sales Order No.');
            end;

            trigger OnAfterGetRecord()
            var
                countryRegion: Record "Country/Region";
                salesPerson: Record "Salesperson/Purchaser";
            begin
                if (countryRegion.Get("Sell-to Country/Region Code")) then begin
                    countryRegionName := countryRegion.Name;
                end;
                if salesPerson.Get("Salesperson Code") then begin
                    salesPersonName := salesPerson.Name;
                end;
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group("Filter: Sales Order(KSS)")
                {
                    field(orderNo; orderNo)
                    {
                        Caption = 'Sales Order No.';
                        ApplicationArea = All;
                        TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
                    }

                    field(billToCustNo; billToCustNo)
                    {
                        Caption = 'Bill-to Customer No.';
                        ApplicationArea = All;
                        TableRelation = Customer."No.";
                    }

                    field(sellToCustNo; sellToCustNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Sell-to Customer No.';
                        TableRelation = Customer."No.";
                    }

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    trigger OnPreReport()
    var
        outStr: OutStream;
    begin
        companyInfo.Get;
        companyInfo.CalcFields(Picture);
        if companyInfo.Picture.HasValue then begin
            companyInfo.Picture.CreateInStream(companyLogoStream);
            tempBlob.CreateOutStream(outStr);
            CopyStream(outStr, companyLogoStream);
        end;
        assignValueToComapnyArray();
    end;

    procedure assignValueToComapnyArray()
    begin
        companyArray[1] := companyInfo.Name;
        companyArray[2] := companyInfo.Address;
        companyArray[3] := companyInfo."Address 2";
        companyArray[4] := companyInfo.City + ', ' + companyInfo.County + ' ' + companyInfo."Post Code";
        companyArray[5] := companyInfo."Bank Name";
        companyArray[6] := companyInfo."Bank Branch No.";
        companyArray[7] := companyInfo."Bank Account No.";
        companyArray[8] := companyInfo.IBAN;
        companyArray[9] := companyInfo."SWIFT Code";
        companyArray[10] := companyInfo."Giro No.";
        // companyArray[11] := companyInfo."Home Page";
        companyArray[11] := companyInfo."Phone No.";
        companyArray[12] := companyInfo."E-Mail";
        CompressArray(companyArray);
    end;

    var
        orderNo: Code[100];
        billToCustNo: Code[30];
        sellToCustNo: Code[30];
        countryRegionName: Text[50];
        companyInfo: record "Company Information";
        companyArray: array[13] of Text;
        companyLogoStream: InStream;
        tempBlob: Codeunit "Temp Blob";
        salesPersonName: Text[50];
}