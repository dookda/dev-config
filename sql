// st_intersect
WITH provbuf AS (
         SELECT st_transform(st_buffer(st_transform(p.geom, 32647), 10000::double precision), 4326) AS geom,
            p.gid
           FROM ud_province_4326 p
        )
 SELECT DISTINCT m.geom,
    m.sta_id,
    m.sta_name,
    m.sta_source
   FROM provbuf b,
    rain_station_th m
    
// union with last update

CREATE OR REPLACE VIEW rain_now AS 
 SELECT x.sta_id,
    x.rain_mm,
    x.tstamp
   FROM ( SELECT DISTINCT ON (b.station_id) b.station_id AS sta_id,
            b.rain AS rain_mm,
            b.raindate AS tstamp
           FROM rain_community b
          WHERE to_char(b.raindate::timestamp with time zone, 'DD/MM/YY'::text) = to_char(timezone('Asia/Bangkok'::text, now()), 'DD/MM/YY'::text) AND b.rain > 0::numeric
          ORDER BY b.station_id, b.raindate DESC) x
UNION
 SELECT y.sta_id,
    y.rain_mm,
    y.tstamp
   FROM ( SELECT DISTINCT ON (a.station_id) a.station_id AS sta_id,
            a.rain_3hr AS rain_mm,
            a.tstamp
           FROM rain_auto_300sec a
          WHERE to_char(a.tstamp, 'DD/MM/YY'::text) = to_char(timezone('Asia/Bangkok'::text, now()), 'DD/MM/YY'::text) AND a.rain_3hr > 0::double precision
          ORDER BY a.station_id, a.tstamp DESC) y
UNION
 SELECT z.sta_id,
    z.rain_mm,
    z.tstamp
   FROM ( SELECT DISTINCT ON (c.station_id) c.station_id AS sta_id,
            c.rain_7hr AS rain_mm,
            c.tstamp
           FROM rain_dwr c
          WHERE to_char(c.tstamp, 'DD/MM/YY'::text) = to_char(timezone('Asia/Bangkok'::text, now()), 'DD/MM/YY'::text) AND c.rain_7hr > 0::double precision
          ORDER BY c.station_id, c.tstamp DESC) z
UNION
 SELECT w.sta_id,
    w.rain_mm,
    w.tstamp
   FROM ( SELECT DISTINCT ON (d.sta_number) d.sta_number AS sta_id,
            d.rain AS rain_mm,
            d.tstamp
           FROM rain_tmd d
          WHERE to_char(d.tstamp, 'DD/MM/YY'::text) = to_char(timezone('Asia/Bangkok'::text, now()), 'DD/MM/YY'::text) AND d.rain > 0::double precision
          ORDER BY d.sta_number, d.tstamp DESC) w;
