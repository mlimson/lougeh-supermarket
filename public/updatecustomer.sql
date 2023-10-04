create procedure updatecustomer(INOUT cuscode integer, IN first character varying, IN last character varying, IN street character varying, IN city character varying, IN country character varying, IN contact character varying)
    language plpgsql
as
$$
    BEGIN
        UPDATE Customers SET FirstName=first WHERE CustomerCode = cusCode AND FirstName <> first;
        UPDATE Customers SET LastName=last WHERE CustomerCode = cusCode AND LastName <> last;
        UPDATE CustomerAddress SET CStreet=street WHERE CustomerCode = cusCode AND CStreet <> street;
        UPDATE CustomerAddress SET CCity=city WHERE CustomerCode = cusCode AND CCity <> city;
        UPDATE CustomerAddress SET CCountry=country WHERE CustomerCode = cusCode AND CCountry <> country;
        UPDATE CustomerContact SET CContactNumber=contact WHERE CAddressId = (SELECT CAddressId FROM CustomerAddress WHERE CustomerCode = cusCode) AND CContactNumber<>contact;
        COMMIT;
    END
$$;

alter procedure updatecustomer(inout integer, varchar, varchar, varchar, varchar, varchar, varchar) owner to postgres;

