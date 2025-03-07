pageextension 50800 salesOrderPageEXT extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            action(printReport_KSS)
            {
                Caption = 'Print Report_KSS';
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                trigger OnAction()
                begin
                    Report.Run(Report::salesOrderPrintTask, true);
                end;
            }
        }
    }

    var
        myInt: Integer;
}