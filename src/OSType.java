import org.eclipse.imp.pdb.facts.IString;
import org.eclipse.imp.pdb.facts.IValueFactory;


public class OSType {
	private final IValueFactory vf;

	public OSType(IValueFactory vf) {
		this.vf = vf;
	}
	
	public IString os () {
		return vf.string(System.getProperty("os.name"));
	}
	
	public IString homeDir () {
		return vf.string(System.getProperty("user.home"));
	} 
}