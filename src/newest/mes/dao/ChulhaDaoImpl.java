package newest.mes.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import newest.mes.model.ChulhaInfo;
import newest.mes.model.ChulhaInfoDetail;
import newest.mes.viewmodel.ChulhaInfoViewModel;

public class ChulhaDaoImpl implements ChulhaDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(ChulhaDaoImpl.class.getName());
	
	public ChulhaDaoImpl() {
	}

	@Override
	public List<ChulhaInfoViewModel> getChulhaInfo(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	CI.chulha_no,\n")
					.append("	CI.chulha_date,\n")
					.append("	PC.customer_name\n")
					.append("FROM mes_chulha_info CI\n")
					.append("INNER JOIN mes_product_customer PC\n")
					.append("	ON CI.customer_code = PC.customer_code \n")
					.append("WHERE CI.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("GROUP BY CI.chulha_no\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ChulhaInfoViewModel> list = new ArrayList<ChulhaInfoViewModel>();
			
			while(rs.next()) {
				ChulhaInfoViewModel data = extractFromResultSet1(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<ChulhaInfoViewModel> getChulhaInfoDetail(Connection conn, String chulhaNo) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	c.chulha_no,\n")
					.append("	c.product_id,\n")
					.append("	p.product_name,\n")
					.append("	c.chulha_count,\n")
					.append("	c.return_count,\n")
					.append("	c.return_type\n")
					.append("FROM mes_chulha_info_detail c\n")
					.append("INNER JOIN product p\n")
					.append("	ON c.product_id = p.product_id\n")
					.append("WHERE c.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND c.chulha_no = '" + chulhaNo + "'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ChulhaInfoViewModel> list = new ArrayList<ChulhaInfoViewModel>();
			
			while(rs.next()) {
				ChulhaInfoViewModel data = extractFromResultSet2(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean insert(Connection conn, ChulhaInfo ci) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_chulha_info (\n")
					.append("		tenant_id, \n")
					.append("		chulha_no,\n")
					.append("		chulha_date,\n")
					.append("		customer_code\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'" + JDBCConnectionPool.getTenantId(conn) + "',\n")
					.append("		'" + ci.getChulhaNo() + "',\n")
					.append("		'" + ci.getChulhaDate() + "',\n")
					.append("		'" + ci.getCustomerCode() + "'\n")
					.append("	);\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);
			logger.debug("i:" + i);
	        if(i == 1) { return true; }
	    } catch (Exception e) {
	    	logger.error(e.getMessage());
	    } finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return false;
	}
	
	@Override
	public boolean insert(Connection conn, ChulhaInfoDetail cid) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_chulha_info_detail (\n")
					.append("		tenant_id, \n")
					.append("		chulha_no,\n")
					.append("		product_id,\n")
					.append("		chulha_count,\n")
					.append("		return_count,\n")
					.append("		return_type\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'" + JDBCConnectionPool.getTenantId(conn) + "',\n")
					.append("		'" + cid.getChulhaNo() + "',\n")
					.append("		'" + cid.getProductId() + "',\n")
					.append("		'" + cid.getChulhaCount() + "',\n")
					.append("		'" + cid.getReturnCount() + "',\n")
					.append("		'" + cid.getReturnType() + "'\n")
					.append("	);\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);
			if(i == 1) { return true; }
		} catch (Exception ex) {
			logger.error(ex.getMessage());
		} finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	@Override
	public boolean update(Connection conn, ChulhaInfo ci) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_chulha_info\n")
					.append("SET\n")
					.append("	chulha_date = '" + ci.getChulhaDate() + "',\n")
					.append("	customer_code = '" + ci.getCustomerCode() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND chulha_no='" + ci.getChulhaNo() + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    } finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return false;
	}
	
	@Override
	public boolean update(Connection conn, ChulhaInfoDetail cid) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_chulha_info_detail\n")
					.append("SET\n")
					.append("	chulha_count = '" + cid.getChulhaCount() + "',\n")
					.append("	return_count = '" + cid.getReturnCount() + "',\n")
					.append("	return_type = '" + cid.getReturnType() + "'\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND chulha_no ='" + cid.getChulhaNo() + "';\n")
					.append("  AND product_id ='" + cid.getProductId() + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) { return true; }
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    } finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String chulhaNo) {
		
		String sql = "";
		
		try {
			conn.setAutoCommit(false);
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("DELETE FROM mes_chulha_info \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND chulha_no='" + chulhaNo + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);
	        if(i < 1) { 
	        	conn.rollback(); 
	        	return false;
	        }

	        sql = new StringBuilder()
	        		.append("DELETE FROM mes_chulha_info_detail \n")
	        		.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
	        		.append("	AND chulha_no='" + chulhaNo + "';\n")
	        		.toString();
	        
	        logger.debug("sql:\n" + sql);
	        
	        i = stmt.executeUpdate(sql);
	        if(i < 1) { 
	        	conn.rollback(); 
	        	return false;
	        }
	        
	        conn.commit();
	        return true;
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    } finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return false;
	}
	
	private ChulhaInfoViewModel extractFromResultSet1(ResultSet rs) throws SQLException {
		
		ChulhaInfoViewModel vm = new ChulhaInfoViewModel();
		
		vm.setChulhaNo(rs.getString("chulha_no"));
		vm.setChulhaDate(rs.getDate("chulha_date").toString());
		vm.setCustomerName(rs.getString("customer_name"));
		
		return vm;
	}

	private ChulhaInfoViewModel extractFromResultSet2(ResultSet rs) throws SQLException {
		
		ChulhaInfoViewModel vm = new ChulhaInfoViewModel();
		
		vm.setChulhaNo(rs.getString("chulha_no"));
		vm.setProductId(rs.getString("product_id"));
		vm.setProductName(rs.getString("product_name"));
		vm.setChulhaCount(rs.getInt("chulha_count"));
		vm.setReturnCount(rs.getInt("return_count"));
		vm.setReturnType(rs.getString("return_type"));
		
		return vm;
	}
}
