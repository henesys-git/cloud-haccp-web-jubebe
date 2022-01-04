package mes.dao;

import java.sql.Connection;
import java.util.List;

import mes.model.Part;

public interface PartDao {
	public List<Part> getAllParts(Connection conn);
	public Part getPart(Connection conn, String partCd, int revisionNo);
	public boolean updatePart(Connection conn, Part part);
	public boolean deletePart(Connection conn, Part part);
}
