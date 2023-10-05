create procedure additem(IN itmbarcode character, IN itmdescription character varying, IN itmuom integer, IN itmprice numeric, IN itmuomid integer DEFAULT 0, INOUT itmcode integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        INSERT INTO Item (itembarcode, itemdescription, itemprice) VALUES (itmBarcode, itmDescription, itmPrice)
        RETURNING (SELECT currval('item_itemcode_seq')) INTO itmCode;

        INSERT INTO itemuom (itemcode, uomid) VALUES (itmCode, itmUom)
        RETURNING (SELECT currval('itemuom_uniqueid_seq')) INTO itmUomId;

        INSERT INTO inventory (itemcode, itemuomid, itemstock) VALUES (itmCode, itmUomId, 0);
        COMMIT;
    END
$$;

alter procedure additem(char, varchar, integer, numeric, integer, inout integer) owner to postgres;

