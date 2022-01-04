package mes.webpush;

import java.security.interfaces.ECPrivateKey;
import java.security.interfaces.ECPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

public class ServerKeys {
	
//	private Connection con = null;
//	private Statement stmt = null;
//	private boolean keyExists = false;
	
//	private final AppProperties appProperties;

  	private ECPublicKey publicKey;

  	private byte[] publicKeyUncompressed;

  	private String publicKeyBase64;

  	private ECPrivateKey privateKey;

  	private final CryptoService cryptoService;
  	
  	private byte[] appServerPublicKey;
	private byte[] appServerPrivateKey;
  	
	public ServerKeys(AppProperties appProperties, CryptoService cryptoService) {
		String publicKey = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEtxDTiibNRxprx4xa/zOXSrnJjzyzsGTblLuT+YzkOf5z8raWLJK72V+NsiIdBe/NVx/QaojR/nI4M3qREUvqGQ==";
		String privateKey = "MEECAQAwEwYHKoZIzj0CAQYIKoZIzj0DAQcEJzAlAgEBBCCEuKIHg+Q9kFC8N3IFM9QObg3DZp7M/H6us+PFq0yJAA==";
		
		this.appServerPublicKey = Base64.getDecoder().decode(publicKey);
		this.appServerPrivateKey = Base64.getDecoder().decode(privateKey);
		
//		this.appProperties = appProperties;
		this.cryptoService = cryptoService;
		
		try {
			initKeys();
		} catch (InvalidKeySpecException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public byte[] getPublicKeyUncompressed() {
		return this.publicKeyUncompressed;
	}

	public String getPublicKeyBase64() {
		return this.publicKeyBase64;
	}

	public ECPrivateKey getPrivateKey() {
		return this.privateKey;
	}

	public ECPublicKey getPublicKey() {
		return this.publicKey;
	}

	private void initKeys() throws InvalidKeySpecException {
		
		this.publicKey = (ECPublicKey) this.cryptoService
            .convertX509ToECPublicKey(appServerPublicKey);
        
		this.privateKey = (ECPrivateKey) this.cryptoService
            .convertPKCS8ToECPrivateKey(appServerPrivateKey);
        
        this.publicKeyUncompressed = CryptoService
            .toUncompressedECPublicKey(this.publicKey);
        
        this.publicKeyBase64 = Base64.getUrlEncoder().withoutPadding()
            .encodeToString(this.publicKeyUncompressed);
        
	}
	
	// not used. to be deleted
//	private boolean selectKeys() {
//		boolean hasKey = false;
//
//		try {
//			con = JDBCConnectionPool.getConnection();
//			stmt = con.createStatement();
//
//			String sql = new StringBuilder()
//					.append("SELECT\n")
//					.append("	mainkey,\n")
//					.append("	public_key,\n")
//					.append("	private_key\n")
//					.append("FROM\n")
//					.append("	testtable;\n")
//					.toString();
//			
//			ResultSet rs = stmt.executeQuery(sql);
//			
//			if(rs.next()) {
//				appServerPublicKey = rs.getString("public_key").getBytes();
//				appServerPrivateKey = rs.getString("private_key").getBytes();
//				hasKey = true;
//			}
//		} catch (SQLException ex) {
//			ex.printStackTrace();
//		} finally {
//			if(stmt != null) {
//				try {
//					stmt.close();
//				} catch (SQLException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//			}
//		}
//		
//		return hasKey;
//	}
	
	// not used. to be deleted
//	private void insertKeys() {
//		try {
//			con = JDBCConnectionPool.getConnection();
//			stmt = con.createStatement();
//			
//			String sql = new StringBuilder()
//				.append("INSERT INTO testtable (					\n")
//				.append("	mainkey,								\n")
//				.append("	public_key,								\n")
//				.append("	private_key								\n")
//				.append(")											\n")
//				.append("VALUES (									\n")
//				.append("	'main',									\n")
//				.append("	'" + this.publicKey.getEncoded() + "',	\n")
//				.append("	'" + this.privateKey.getEncoded() + "'	\n")
//				.append(");											\n")
//				.toString();
//			
//			stmt.executeUpdate(sql);
//		} catch (SQLException ex) {
//			ex.printStackTrace();
//		} finally {
//			if(stmt != null) {
//				try {
//					stmt.close();
//				} catch (SQLException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//			}
//		}
//	}
}
