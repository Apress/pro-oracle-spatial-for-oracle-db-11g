-- Listing 5-25. Converting a GML Solid Geometry into an SDO_GEOMETRY
SELECT SDO_UTIL.FROM_GML311GEOMETRY(
TO_CLOB(
'<gml:Solid srsName="SDO:" xmlns:gml="http://www.opengis.net/gml">
<gml:exterior>
<gml:CompositeSurface>
<gml:surfaceMember>
<gml:Polygon>
<gml:exterior>
<gml:LinearRing>
<gml:posList srsDimension="3">
0.0 0.0 0.0 0.0 4.0 0.0 4.0 4.0 0.0 4.0 0.0 0.0 0.0 0.0 0.0
</gml:posList>
</gml:LinearRing>
</gml:exterior>
</gml:Polygon>
</gml:surfaceMember>
<gml:surfaceMember>
<gml:Polygon>
<gml:exterior>
<gml:LinearRing>
<gml:posList srsDimension="3">
4.0 4.0 4.0 0.0 4.0 4.0 0.0 0.0 4.0 4.0 0.0 4.0 4.0 4.0 4.0
</gml:posList>
</gml:LinearRing>
</gml:exterior>
</gml:Polygon>
</gml:surfaceMember>
<gml:surfaceMember>
<gml:Polygon>
<gml:exterior>
<gml:LinearRing>
<gml:posList srsDimension="3">
0.0 0.0 0.0 4.0 0.0 0.0 4.0 0.0 4.0 0.0 0.0 4.0 0.0 0.0 0.0
</gml:posList>
</gml:LinearRing>
</gml:exterior>
</gml:Polygon>
</gml:surfaceMember>
<gml:surfaceMember>
<gml:Polygon>
<gml:exterior>
<gml:LinearRing>
<gml:posList srsDimension="3">
0.0 0.0 0.0 0.0 0.0 4.0 0.0 4.0 4.0 0.0 4.0 0.0 0.0 0.0 0.0
</gml:posList>
</gml:LinearRing>
</gml:exterior>
</gml:Polygon>
</gml:surfaceMember>
<gml:surfaceMember>
<gml:Polygon>
<gml:exterior>
<gml:LinearRing>
<gml:posList srsDimension="3">
4.0 4.0 4.0 4.0 4.0 0.0 0.0 4.0 0.0 0.0 4.0 4.0 4.0 4.0 4.0
</gml:posList>
</gml:LinearRing>
</gml:exterior>
</gml:Polygon>
</gml:surfaceMember>
<gml:surfaceMember>
<gml:Polygon>
<gml:exterior>
<gml:LinearRing>
<gml:posList srsDimension="3">
4.0 4.0 4.0 4.0 0.0 4.0 4.0 0.0 0.0 4.0 4.0 0.0 4.0 4.0 4.0
</gml:posList>
</gml:LinearRing>
</gml:exterior>
</gml:Polygon>
</gml:surfaceMember>
</gml:CompositeSurface>
</gml:exterior>
</gml:Solid>'
)) GEOM FROM DUAL;
