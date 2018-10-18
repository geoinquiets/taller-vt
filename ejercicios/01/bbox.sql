CREATE OR REPLACE FUNCTION BBox(z integer, x integer, y integer)
    RETURNS geometry AS
$BODY$
DECLARE
    max numeric := 6378137 * pi();
    res numeric := max * 2 / 2^z;
BEGIN
    return ST_MakeEnvelope(
        -max + (x * res),
        max - (y * res),
        -max + (x * res) + res,
        max - (y * res) - res,
        3857);
END;
$BODY$
  LANGUAGE plpgsql;
