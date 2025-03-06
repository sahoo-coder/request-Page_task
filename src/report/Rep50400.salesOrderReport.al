report 50502 salesOrderReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './salesOrderReport.rdl';
    Caption = 'Sales_Order_Report_KSS';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {


            column(No_; "No.") { }
            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                Message('On Post Data Item');
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Message('On after get record');
                if "Sales Header"."Sell-to Customer No." = '10000' then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                Message('On Pre data item');
                // "Sales Header".SetFilter("Document Type", '%1', "Sales Header"."Document Type"::Order);
                "Sales Header".SetRange("No.", salesOrder);
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
                group(GroupName)
                {
                    field(salesOrder; salesOrder)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Order Number';
                        TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
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
    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        Message('On Post Report');
    end;

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        Message('On Init Report');
    end;

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        Message('On Pre Report');
    end;


    var
        salesOrder: Code[150];
}