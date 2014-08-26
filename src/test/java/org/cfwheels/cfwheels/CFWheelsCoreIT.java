package org.cfwheels.cfwheels;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Collection;
import java.util.concurrent.TimeUnit;

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

/**
 * Integration Tests (IT) to run during Maven integration-test phase
 * See pom.xml for usage
 *
 * @author Singgih
 *
 */
@RunWith(Parameterized.class)
public class CFWheelsCoreIT {
	static final private String[] KNOWN_ERRORS={"The data source could not be reached."};
	static private CustomHtmlUnitDriver driver;
	static private String baseUrl;
	static private boolean testOracleEmulation;
	static private String currentContextPath="";
	private String contextPath;
	private String packageName;

	public CFWheelsCoreIT(String contextPath, String packageName) {
		super();
		this.contextPath = contextPath;
		this.packageName = packageName;
	}

	/**
	 * @return scan folder for cfwheels core unit tests and add them as parameterized jUnit tests
	 */
	@Parameters(name="package {0}{1}")
    public static Collection<Object[]> getDirectories() {
    	Collection<Object[]> params = new ArrayList<Object[]>();
    	addSubDirectories(params, "/", "", "wheels/tests");
		if ("true".equals(System.getProperty("testSubfolder"))) {
	    	addSubDirectories(params, "/subfolder/", "", "wheels/tests");
		}
		String secondPort=System.getProperty("testSecondPort");
		if (secondPort != null) {
	    	addSubDirectories(params, ":" + secondPort + "/", "", "wheels/tests");
		}

    	return params;
    }

	private static boolean addSubDirectories(Collection<Object[]> params, String contextPath, String prefix, String path) {
		boolean added = false;
		for (File f : new File(path).listFiles()) {
			if (f.getName().startsWith("_")) continue;
    		if (!f.isDirectory()) {
    			continue;
    		}
			if (addSubDirectories(params, contextPath, prefix + f.getName() + ".", f.getPath())) {
	    		added = true;
				continue;
			}
			
			Object[] arr = new Object[] {contextPath, prefix + f.getName() };
    		params.add(arr);
    		added = true;
    	}
		return added;
	}
    
	/**
	 * Taking backup of key cfwheels files and initializing test database once (unzip cfwheels only on remote server)
	 * @throws Exception
	 */
	@BeforeClass
	static public void setUpServices() throws Exception {
		Files.copy(Paths.get("wheels/Connection.cfc"), Paths.get("wheels/Connection.cfc.bak"), StandardCopyOption.REPLACE_EXISTING);
		Files.copy(Paths.get("wheels/tests/populate.cfm"), Paths.get("wheels/tests/populate.cfm.bak"), StandardCopyOption.REPLACE_EXISTING);
		Path path = Paths.get("target/failsafe-reports");

		if (!Files.exists(path)) Files.createDirectory(path);
		driver = new CustomHtmlUnitDriver();
		baseUrl = "http://localhost:8080";
		if (null != System.getProperty("testServer")) baseUrl = System.getProperty("testServer");
    	testOracleEmulation = Boolean.valueOf(System.getProperty("testOracleEmulation"));
		driver.manage().timeouts().implicitlyWait(30000, TimeUnit.SECONDS);

		if (null != System.getProperty("deployUrl")) {
			System.out.println("cfwheels deploy");
			if ("true".equals(System.getProperty("testSubfolder"))) {
				driver.get(System.getProperty("deployUrl") + "&subfolder=true");
			} else {
				driver.get(System.getProperty("deployUrl"));
			}
	        String pageSource = driver.getPageSource();
			Files.write(Paths.get("target/failsafe-reports/_deploy.html"), pageSource.getBytes());
		}

	}
	
	@Before
	public void setUp() throws IOException {
		if (! currentContextPath.equals(contextPath) && ! contextPath.equals("/subfolder/")) {
			recreateTestDatabase();
			currentContextPath = contextPath;
		}
	}

	public static void main(String[] args) throws Exception {
		System.setProperty("testOracleEmulation", "true");
		setUpServices();
	}

	private static void recreateTestDatabase() throws IOException {
		if (testOracleEmulation) {
			String content = new String(Files.readAllBytes(Paths.get("wheels/Connection.cfc")));
			content = content.replace("loc.adapterName = \"H2\"","loc.adapterName = 'Oracle'");
			Files.write(Paths.get("wheels/Connection.cfc"), content.getBytes());

			content = new String(Files.readAllBytes(Paths.get("src/test/coldfusion/_oracle-emu.cfm")));
			content += new String(Files.readAllBytes(Paths.get("wheels/tests/populate.cfm")));
			content = content.replace("loc.dbinfo.database_productname","'Oracle'");
			content = content.replace("booleanType bit DEFAULT 0 NOT NULL","booleanType number(1) DEFAULT 0 NOT NULL");
			content = content.replace("to_timestamp(#loc.dateTimeDefault#,'yyyy-dd-mm hh24:mi:ss.FF')","'2000-01-01 18:26:08.690'");
			content = content.replace("CREATE TRIGGER bi_#loc.i# BEFORE INSERT ON #loc.i# FOR EACH ROW BEGIN SELECT #loc.seq#.nextval INTO :NEW.<cfif loc.i IS \"photogalleries\">photogalleryid<cfelseif loc.i IS \"photogalleryphotos\">photogalleryphotoid<cfelse>id</cfif> FROM dual; END;",
					"ALTER TABLE #loc.i# MODIFY COLUMN <cfif loc.i IS \"photogalleries\">photogalleryid<cfelseif loc.i IS \"photogalleryphotos\">photogalleryphotoid<cfelse>id</cfif> #loc.identityColumnType# DEFAULT #loc.seq#.nextval");
			Files.write(Paths.get("wheels/tests/populate.cfm"), content.getBytes());
		}
		if ("true".equals(System.getProperty("testParallelStart"))) {
			hitHomepageWithParallelRequest();
		}
		System.out.println("test database re-create");
		driver.get(baseUrl + "/index.cfm?controller=wheels&action=wheels&view=tests&type=core&reload=true&package=controller.caching");
		String postfix = "";
        String pageSource = driver.getPageSource();
        if (!pageSource.contains("Passed")) {
        	System.out.println(driver.getPageSourceAsText());
        	postfix = "-ERROR";
        }
		Files.write(Paths.get("target/failsafe-reports/_databaseRecreate" + postfix + ".html"), pageSource.getBytes());
	}

	private static class HitterThread extends Thread {
		@Override
		public void run() {
			CustomHtmlUnitDriver driver = new CustomHtmlUnitDriver();
			driver.get(baseUrl);
			String postfix = "";
	        String pageSource = driver.getPageSource();
	        if (!pageSource.contains("Congratulation")) {
	        	System.out.println(driver.getPageSourceAsText());
	        	postfix = "-ERROR";
	        }
			try {
				Files.write(Paths.get("target/failsafe-reports/_index" + postfix + ".html"), pageSource.getBytes());
			} catch (IOException e) {
				e.printStackTrace();
			}
			driver.quit();
		}
	}
	
	private static void hitHomepageWithParallelRequest() {
		new HitterThread().start();
		new HitterThread().start();
	}

	/**
	 * Generic test, to be parameterized per cfwheels app test package and database
	 * @throws IOException
	 */
	@Test
	public void testCFWheels() throws IOException {
		System.out.print(contextPath);
		System.out.println(packageName);
		String packageUrl = baseUrl + contextPath + "index.cfm?controller=wheels&action=wheels&view=tests&type=core&package="+packageName;
		driver.get(packageUrl);
        String pageSource = driver.getPageSource();
        assertTrue("The page should have results",pageSource.trim().length()>0);
        String postfix="";
        // show error detail on Maven log if needed
        if (!pageSource.contains("Passed")) {
        	System.out.println(driver.getPageSourceAsText());
        	postfix = "-ERROR";
        }
        // write error detail on per test html report on failsafe-report folder
		Files.write(Paths.get("target/failsafe-reports/cfwheels-" + packageName + postfix + ".html"), pageSource.getBytes());
        for (String error:KNOWN_ERRORS) {
        	if (pageSource.contains(error)) fail(error + " " + packageUrl);
        }
        assertTrue("The page should have passed " + packageUrl,pageSource.contains("Passed"));
	}

	/**
	 * closing down the web driver client and restoring key cfwheels files to original state
	 * @throws Exception
	 */
	@AfterClass
	static public void tearDownServices() throws Exception {
		Files.copy(Paths.get("wheels/Connection.cfc.bak"), Paths.get("wheels/Connection.cfc"), StandardCopyOption.REPLACE_EXISTING);
		Files.copy(Paths.get("wheels/tests/populate.cfm.bak"), Paths.get("wheels/tests/populate.cfm"), StandardCopyOption.REPLACE_EXISTING);
		Files.delete(Paths.get("wheels/Connection.cfc.bak"));
		Files.delete(Paths.get("wheels/tests/populate.cfm.bak"));

		driver.quit();
	}

}
