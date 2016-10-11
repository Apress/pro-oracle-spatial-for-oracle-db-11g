-- Listing 5-24. Converting Multiple Geometries to a GML Document Fragment
SELECT xmlelement(
  "State",
  xmlattributes('http://www.opengis.net/gml' as "xmlns:gml"),
  xmlforest(state as "Name", totpop as "Population",
  xmltype(sdo_util.to_gmlgeometry(geom)) as
  "gml:geometryProperty"))
AS theXMLElements
FROM spatial.us_states
WHERE state_abrv in ('DE', 'UT');
