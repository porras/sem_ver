require 'rspec'
require 'sem_ver'

describe SemVer do
  describe '.parse' do
    describe 'normal' do
      let(:version) { SemVer.parse('3.1.2') }
      
      example { version.major.should == 3 }
      example { version.minor.should == 1 }
      example { version.patch.should == 2 }
      example { version.prerelease.should == nil }
      
      describe 'order' do
        example { SemVer.parse('0.0.10').should > SemVer.parse('0.0.9') }
        example { SemVer.parse('0.1.0').should > SemVer.parse('0.0.2') }
        example { SemVer.parse('1.0.0').should > SemVer.parse('0.9.9') }
        
        example { SemVer.parse('0.0.1').should < SemVer.parse('0.0.2') }
        example { SemVer.parse('0.0.2').should < SemVer.parse('0.1.0') }
        example { SemVer.parse('0.9.9').should < SemVer.parse('1.0.0') }
        
        example { SemVer.parse('0.0.1').should == SemVer.parse('0.0.1') }
        example { SemVer.parse('0.0.2').should == SemVer.parse('0.0.2') }
        example { SemVer.parse('0.9.9').should == SemVer.parse('0.9.9') }
      end
    end
    
    describe 'prereleases' do
      let(:version) { SemVer.parse('1.0.11-rc2') }
      
      example { version.major.should == 1 }
      example { version.minor.should == 0 }
      example { version.patch.should == 11 }
      example { version.prerelease.should == 'rc2' }
      
      describe 'order' do
        example { SemVer.parse('1.0.0').should > SemVer.parse('1.0.0-rc15') }
        example { SemVer.parse('1.0.0-rc15').should < SemVer.parse('1.0.0') }
        example { SemVer.parse('1.0.0-rc15').should == SemVer.parse('1.0.0-rc15') }
        example { SemVer.parse('1.0.0-rc16').should > SemVer.parse('1.0.0-rc15') }
        example { SemVer.parse('1.0.1-rc14').should > SemVer.parse('1.0.0-rc15') }
        example { SemVer.parse('1.0.1-rc15').should > SemVer.parse('1.0.0-rc15') }
      end
    end
    
    describe 'vX.Y.Z' do
      let(:version) { SemVer.parse('v3.1.2') }
      
      example { version.major.should == 3 }
      example { version.minor.should == 1 }
      example { version.patch.should == 2 }
      example { version.prerelease.should == nil }
      
      describe 'equivalence' do
        example { SemVer.parse('v0.0.1').should == SemVer.parse('0.0.1') }
        example { SemVer.parse('v0.0.2').should == SemVer.parse('0.0.2') }
        example { SemVer.parse('v0.9.9').should == SemVer.parse('0.9.9') }
      end
    end
  end
  
  describe '#valid?' do
    example { SemVer.parse('1.0.0').should be_valid }
    example { SemVer.parse('v1.0.0').should be_valid }
    example { SemVer.parse('1.0.0-rc1').should be_valid }
    example { SemVer.parse('v1.0.0-rc1').should be_valid }
    
    example { SemVer.parse('v1.0.0-').should_not be_valid }
    example { SemVer.parse('1.0.0-').should_not be_valid }
    
    example { SemVer.parse('1.0-rc1').should_not be_valid }
    example { SemVer.parse('v1.0-rc1').should_not be_valid }
    
    example { SemVer.parse('1-rc1').should_not be_valid }
    example { SemVer.parse('v1-rc1').should_not be_valid }
    
    example { SemVer.parse('1.0').should_not be_valid }
    example { SemVer.parse('v1.0').should_not be_valid }
    
    example { SemVer.parse('1').should_not be_valid }
    example { SemVer.parse('v1').should_not be_valid }
    
    example { SemVer.parse('X.0.0').should_not be_valid }
    example { SemVer.parse('vX.0.0').should_not be_valid }
    example { SemVer.parse('X.0.0-rc1').should_not be_valid }
    example { SemVer.parse('vX.0.0-rc1').should_not be_valid }
    example { SemVer.parse('1.X.0').should_not be_valid }
    example { SemVer.parse('v1.X.0').should_not be_valid }
    example { SemVer.parse('1.X.0-rc1').should_not be_valid }
    example { SemVer.parse('v1.X.0-rc1').should_not be_valid }
    example { SemVer.parse('1.0.X').should_not be_valid }
    example { SemVer.parse('v1.0.X').should_not be_valid }
    example { SemVer.parse('1.0.X-rc1').should_not be_valid }
    example { SemVer.parse('v1.0.X-rc1').should_not be_valid }
    
    describe 'using a invalid version' do
      let(:invalid_version) { SemVer.parse('1.0.wadus-rc1') }
      
      example { invalid_version.major.should == nil }
      example { invalid_version.minor.should == nil }
      example { invalid_version.patch.should == nil }
      example { invalid_version.prerelease.should == nil }
      
      describe 'comparing' do
        let(:valid_version) { SemVer.parse('1.0.0') }
        
        example { expect { invalid_version < valid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { valid_version < invalid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { invalid_version <= valid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { valid_version <= invalid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { invalid_version > valid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { valid_version > invalid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { invalid_version >= valid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { valid_version >= invalid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { invalid_version == valid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { valid_version == invalid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { invalid_version != valid_version }.to raise_error(SemVer::InvalidVersion) }
        example { expect { valid_version != invalid_version }.to raise_error(SemVer::InvalidVersion) }
      end
    end
  end
  
  describe '#to_s' do
    example { SemVer.parse('1.0.0').to_s.should == '1.0.0' }
    example { SemVer.parse('1.0.0-rc15').to_s.should == '1.0.0-rc15' }
    example { SemVer.parse('1.0.wadus').to_s.should == '1.0.wadus' }
  end
  
  describe '#inspect' do
    example { SemVer.parse('1.0.0').inspect.should == '<Version: 1.0.0>' }
    example { SemVer.parse('1.0.0-rc15').inspect.should == '<Version: 1.0.0-rc15>' }
    example { SemVer.parse('1.0.wadus').inspect.should == '<InvalidVersion: 1.0.wadus>' }
  end
end