create procedure additem(IN itmbarcode character, IN itmdescription character varying, IN itmuom integer, IN itmprice numeric, INOUT itmcode integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        INSERT INTO Item (itembarcode, itemdescription, itemprice) VALUES (itmBarcode, itmDescription, itmPrice)
        RETURNING (SELECT currval('item_itemcode_seq')) INTO itmCode;

        INSERT INTO itemuom (itemcode, uomid) VALUES (itmCode, itmUom);
        COMMIT;
    END
$$;

alter procedure additem(char, varchar, integer, numeric, inout integer) owner to postgres;

