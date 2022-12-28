package newest.mes.dao;

import java.sql.Connection;
import java.util.List;

import newest.mes.model.ChulhaInfo;
import newest.mes.model.ChulhaInfoDetail;
import newest.mes.viewmodel.ChulhaInfoViewModel;

public interface ChulhaDao {
	public List<ChulhaInfoViewModel> getChulhaInfo(Connection conn);
	public List<ChulhaInfoViewModel> getChulhaInfoDetail(Connection conn, String chulhaNo);
	public boolean insert(Connection conn, ChulhaInfo chulhaInfo);
	public boolean insert(Connection conn, ChulhaInfoDetail chulhaInfoDetail);
	public boolean update(Connection conn, ChulhaInfo chulhaInfo);
	public boolean update(Connection conn, ChulhaInfoDetail chulhaInfoDetail);
	public boolean delete(Connection conn, String chulhaNo);
}