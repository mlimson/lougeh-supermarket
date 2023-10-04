create procedure addsupplier(IN name character varying, IN street character varying, IN city character varying, IN country character varying, IN contact character varying, INOUT supcode integer DEFAULT 0, INOUT addressid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        INSERT INTO Suppliers (CompanyName, TimeStamp) VALUES (name, current_timestamp)
        RETURNING (SELECT currval('suppliers_suppliercode_seq')) INTO supCode;

        INSERT INTO SupplierAddress (SupplierCode, SStreet, SCity, SCountry) VALUES (supCode, street, city, country)
        RETURNING (SELECT currval('supplieraddress_saddressid_seq')) INTO addressId;

        INSERT INTO SupplierContact (SAddressId, ContactNumber)VALUES (addressId, contact);

        COMMIT;
    END
$$;

alter procedure addsupplier(varchar, varchar, varchar, varchar, varchar, inout integer, inout integer) owner to postgres;

