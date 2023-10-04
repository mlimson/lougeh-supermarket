create procedure updateitem(INOUT itmcode integer, IN itmdescription character varying, IN itmbarcode character, IN itmuom integer, IN itmprice numeric)
    language plpgsql
as
$$
    BEGIN
        UPDATE item SET itemdescription = itmDescription WHERE itemcode = itmCode AND itemdescription <> itmDescription;
        UPDATE item SET itembarcode = itmBarcode WHERE itemcode = itmCode AND itembarcode <> itmBarcode;
        UPDATE item SET itemprice = itmPrice WHERE itemcode = itmCode AND itemprice <> itmPrice;
        UPDATE itemuom SET uomid = itmUom WHERE itemcode = itmCode AND uomid <> itmUom;
        COMMIT;
    END
$$;

alter procedure updateitem(inout integer, varchar, char, integer, numeric) owner to postgres;

