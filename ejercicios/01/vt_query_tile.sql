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

SELECT ST_AsMVT(q, 'mvt_barrios')
FROM (
  SELECT gid, n_barri,
    ST_AsMVTGeom(
      geom,
      BBox(13, 4145, 3059),
      4096,
      0
    ) AS geom
  FROM barrios
  WHERE geom && BBox(13, 4145, 3059)
) AS q;
