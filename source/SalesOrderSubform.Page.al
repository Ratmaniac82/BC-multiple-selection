pageextension 50213 "PPI Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify("No.")
        {
            AssistEdit = true;
            trigger OnAssistEdit()
            var
                ItemList: Page "Item List";
                Item: Record Item;
                SalesLine: Record "Sales Line";
                LineNo: Integer;
            begin
                ItemList.LookupMode := true;
                if ItemList.RunModal = Action::LookupOK then begin
                    SalesLine.SetRange("Document No.", Rec."Document No.");
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    if SalesLine.FindLast() then
                        LineNo := SalesLine."Line No.";

                    Item.SetFilter("No.", ItemList.GetSelectionFilter());
                    if Item.FindSet() then
                        repeat
                            LineNo += 10000;
                            SalesLine.Init();
                            SalesLine."Document Type" := Rec."Document Type";
                            SalesLine."Document No." := Rec."Document No.";
                            SalesLine."Line No." := LineNo;
                            SalesLine.Insert(true);
                            SalesLine.Validate(Type, SalesLine.Type::Item);
                            SalesLine.Validate("no.", Item."No.");
                            SalesLine.Validate(Quantity, 1);
                        until Item.Next() = 0;
                end;
            end;
        }
    }
}