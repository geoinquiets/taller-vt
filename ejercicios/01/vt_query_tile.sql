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
