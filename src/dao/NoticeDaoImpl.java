package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.Notice;

public class NoticeDaoImpl implements NoticeDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(NoticeDaoImpl.class.getName());
	
	
	public NoticeDaoImpl() {
	}
	
	@Override
	public List<Notice> getAllNotice(Connection conn) {

		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT *			\n")
				.append("FROM notice		\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Notice> list = new ArrayList<Notice>();
			
			while(rs.next()) {
				Notice notice = extractFromResultSet(rs);
				list.add(notice);
			}
			
			return list;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public Notice getNotice(Connection conn, String regDatetime) {

		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT *			\n")
				.append("FROM notice		\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND register_datetime = '" + regDatetime + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			if(rs.next()) {
				return extractFromResultSet(rs);
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public List<Notice> getActiveNotice(Connection conn) {

		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT *			\n")
				.append("FROM notice		\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND active = 'Y'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Notice> list = new ArrayList<Notice>();
			
			while(rs.next()) {
				Notice notice = extractFromResultSet(rs);
				list.add(notice);
			}
			
			return list;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public boolean insert(Connection conn, Notice notice) {
		String sql = "";
		try {
			sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	menu (\n")
					.append("		tenant_id,\n")
					.append("		register_datetime,\n")
					.append("		notice_title,\n")
					.append("		notice_content,\n")
					.append("		active\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append(" 		? \n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, notice.getRegisterDatetime());
			ps.setString(3, notice.getNoticeTitle());
			ps.setString(4, notice.getNoticeContent());
			ps.setString(5, notice.getActive());
			
	        int i = ps.executeUpdate();

	        if(i < 0) {
	        	conn.rollback();
	        	return false;
	        }

	        return true;
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean update(Connection conn, Notice notice, String regDatetimeOrg) {
		try {
			stmt = conn.createStatement();

			String sql = new StringBuilder()
					.append("UPDATE notice \n")
					.append("SET\n")
					.append("	notice_title = '" + notice.getNoticeTitle() + "',	 \n")
					.append("	notice_content = '" + notice.getNoticeContent() + "',\n")
					.append("	active = '" + notice.getActive() + "'			 \n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND register_datetime = '" + regDatetimeOrg + "'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String registerDatetime) {
		String sql = "";
		try {
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("DELETE FROM notice\n")
					.append("WHERE tenant_id = '" + registerDatetime + "';\n")
					.append("  AND register_datetime = '" + registerDatetime + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);

			if(i < 0) {
	        	conn.rollback();
	        	return false;
	        }
			
			return true;
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	private Notice extractFromResultSet(ResultSet rs) throws SQLException {
		return new Notice(
				rs.getString("register_datetime"),
				rs.getString("notice_title"),
				rs.getString("notice_content"),
				rs.getString("active")
			);
	}
}
