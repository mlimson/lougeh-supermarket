create procedure updatesupplier(INOUT supcode integer, IN name character varying, IN street character varying, IN city character varying, IN country character varying, IN contact character varying, INOUT addressid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        IF EXISTS(SELECT SupplierCode FROM suppliers WHERE suppliercode=supCode)
            THEN
                UPDATE Suppliers SET CompanyName=name WHERE SupplierCode = supCode AND CompanyName <> name;
                UPDATE SupplierAddress SET SStreet=street WHERE SupplierCode = supCode AND SStreet<>street;
                UPDATE SupplierAddress SET SCity=city WHERE SupplierCode = supCode AND SCity<>city;
                UPDATE SupplierAddress SET SCountry=country WHERE SupplierCode = supCode AND SCountry<>country;
                addressId = (SELECT SAddressId FROM SupplierAddress WHERE SupplierCode=supCode);
                UPDATE SupplierContact SET ContactNumber=contact WHERE SAddressId=addressId AND ContactNumber<>contact;
            ELSE RAISE 'Supplier does not exists.';
        END IF;
        COMMIT;
    END
$$;

alter procedure updatesupplier(inout integer, varchar, varchar, varchar, varchar, varchar, inout integer) owner to postgres;

