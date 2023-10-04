create procedure updatesupplier(INOUT supcode integer, IN name character varying, IN street character varying, IN city character varying, IN country character varying, IN contact character varying, INOUT addressid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        UPDATE Suppliers SET CompanyName=name WHERE SupplierCode = supCode AND CompanyName <> name;
        UPDATE SupplierAddress SET SStreet=street, SCity=city, SCountry=country WHERE SupplierCode = supCode AND SStreet<>street OR SCity=city OR SCountry<>country;
        addressId = (SELECT SAddressId FROM SupplierAddress WHERE SupplierCode=supCode);
        UPDATE SupplierContact SET ContactNumber=contact WHERE SAddressId=addressId AND ContactNumber<>contact;
        COMMIT;
    END
$$;

alter procedure updatesupplier(inout integer, varchar, varchar, varchar, varchar, varchar, inout integer) owner to postgres;

