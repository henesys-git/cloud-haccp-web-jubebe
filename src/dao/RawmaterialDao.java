package dao;

import java.sql.Connection;
import java.util.List;

import model.Rawmaterial;
import viewmodel.RawmaterialViewModel;

public interface RawmaterialDao {
	public List<Rawmaterial> getAllRawmaterials(Connection conn);
	public Rawmaterial getRawmaterial(Connection conn, String id);
	public boolean insert(Connection conn, Rawmaterial rawmaterial);
	public boolean update(Connection conn, Rawmaterial rawmaterial);
	public boolean delete(Connection conn, String id);
	public List<RawmaterialViewModel> getAllRawmaterialsViewModels(Connection conn);
}