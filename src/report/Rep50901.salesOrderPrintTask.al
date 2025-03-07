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

    var
        orderNo: Code[100];
        billToCustNo: Code[30];
        sellToCustNo: Code[30];
}