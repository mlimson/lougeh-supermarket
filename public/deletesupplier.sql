create procedure deletesupplier(INOUT supcode integer, INOUT addressid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        addressId = (SELECT SAddressId FROM SupplierAddress WHERE SupplierCode=supCode);
        DELETE FROM SupplierContact WHERE SAddressId = addressId;
        DELETE FROM SupplierAddress WHERE SupplierCode = supCode;
        DELETE FROM Suppliers WHERE SupplierCode = supCode;
        COMMIT;
    END
$$;

alter procedure deletesupplier(inout integer, inout integer) owner to postgres;

