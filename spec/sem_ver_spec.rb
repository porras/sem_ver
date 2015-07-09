require 'rspec'
require 'sem_ver'

describe SemVer do
  describe '.parse' do
    describe 'normal' do
      let(:version) { SemVer.parse('3.1.2') }

      example { expect(version.major).to eq(3) }
      example { expect(version.minor).to eq(1) }
      example { expect(version.patch).to eq(2) }
      example { expect(version.prerelease).to eq(nil) }

      describe 'order' do
        example { expect(SemVer.parse('0.0.10')).to be > SemVer.parse('0.0.9') }
        example { expect(SemVer.parse('0.1.0')).to be > SemVer.parse('0.0.2') }
        example { expect(SemVer.parse('1.0.0')).to be > SemVer.parse('0.9.9') }

        example { expect(SemVer.parse('0.0.1')).to be < SemVer.parse('0.0.2') }
        example { expect(SemVer.parse('0.0.2')).to be < SemVer.parse('0.1.0') }
        example { expect(SemVer.parse('0.9.9')).to be < SemVer.parse('1.0.0') }

        example { expect(SemVer.parse('0.0.1')).to be == SemVer.parse('0.0.1') }
        example { expect(SemVer.parse('0.0.2')).to be == SemVer.parse('0.0.2') }
        example { expect(SemVer.parse('0.9.9')).to be == SemVer.parse('0.9.9') }
      end
    end

    describe 'prereleases' do
      let(:version) { SemVer.parse('1.0.11-rc2') }

      example { expect(version.major).to eq(1) }
      example { expect(version.minor).to eq(0) }
      example { expect(version.patch).to eq(11) }
      example { expect(version.prerelease).to eq('rc2') }

      describe 'order' do
        example { expect(SemVer.parse('1.0.0')).to be > SemVer.parse('1.0.0-rc15') }
        example { expect(SemVer.parse('1.0.0-rc15')).to be < SemVer.parse('1.0.0') }
        example { expect(SemVer.parse('1.0.0-rc15')).to be == SemVer.parse('1.0.0-rc15') }
        example { expect(SemVer.parse('1.0.0-rc16')).to be > SemVer.parse('1.0.0-rc15') }
        example { expect(SemVer.parse('1.0.1-rc14')).to be > SemVer.parse('1.0.0-rc15') }
        example { expect(SemVer.parse('1.0.1-rc15')).to be > SemVer.parse('1.0.0-rc15') }
        example { expect(SemVer.parse('v1.0.0-rc15')).to be == SemVer.parse('1.0.0-rc15') }
      end
    end

    describe 'vX.Y.Z' do
      let(:version) { SemVer.parse('v3.1.2') }

      example { expect(version.major).to be == 3 }
      example { expect(version.minor).to be == 1 }
      example { expect(version.patch).to be == 2 }
      example { expect(version.prerelease).to be == nil }

      describe 'equivalence' do
        example { expect(SemVer.parse('v0.0.1')).to be == SemVer.parse('0.0.1') }
        example { expect(SemVer.parse('v0.0.2')).to be == SemVer.parse('0.0.2') }
        example { expect(SemVer.parse('v0.9.9')).to be == SemVer.parse('0.9.9') }
      end
    end
  end

  describe '#valid?' do
    example { expect(SemVer.parse('1.0.0')).to be_valid }
    example { expect(SemVer.parse('v1.0.0')).to be_valid }
    example { expect(SemVer.parse('1.0.0-rc1')).to be_valid }
    example { expect(SemVer.parse('v1.0.0-rc1')).to be_valid }

    example { expect(SemVer.parse('v1.0.0-')).to_not be_valid }
    example { expect(SemVer.parse('1.0.0-')).to_not be_valid }

    example { expect(SemVer.parse('1.0-rc1')).to_not be_valid }
    example { expect(SemVer.parse('v1.0-rc1')).to_not be_valid }

    example { expect(SemVer.parse('1-rc1')).to_not be_valid }
    example { expect(SemVer.parse('v1-rc1')).to_not be_valid }

    example { expect(SemVer.parse('1.0')).to_not be_valid }
    example { expect(SemVer.parse('v1.0')).to_not be_valid }

    example { expect(SemVer.parse('1')).to_not be_valid }
    example { expect(SemVer.parse('v1')).to_not be_valid }

    example { expect(SemVer.parse('X.0.0')).to_not be_valid }
    example { expect(SemVer.parse('vX.0.0')).to_not be_valid }
    example { expect(SemVer.parse('X.0.0-rc1')).to_not be_valid }
    example { expect(SemVer.parse('vX.0.0-rc1')).to_not be_valid }
    example { expect(SemVer.parse('1.X.0')).to_not be_valid }
    example { expect(SemVer.parse('v1.X.0')).to_not be_valid }
    example { expect(SemVer.parse('1.X.0-rc1')).to_not be_valid }
    example { expect(SemVer.parse('v1.X.0-rc1')).to_not be_valid }
    example { expect(SemVer.parse('1.0.X')).to_not be_valid }
    example { expect(SemVer.parse('v1.0.X')).to_not be_valid }
    example { expect(SemVer.parse('1.0.X-rc1')).to_not be_valid }
    example { expect(SemVer.parse('v1.0.X-rc1')).to_not be_valid }

    describe 'using a invalid version' do
      let(:invalid_version) { SemVer.parse('1.0.wadus-rc1') }

      example { expect(invalid_version.major).to be == nil }
      example { expect(invalid_version.minor).to be == nil }
      example { expect(invalid_version.patch).to be == nil }
      example { expect(invalid_version.prerelease).to be == nil }

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
    example { expect(SemVer.parse('1.0.0').to_s).to be == '1.0.0' }
    example { expect(SemVer.parse('1.0.0-rc15').to_s).to be == '1.0.0-rc15' }
    example { expect(SemVer.parse('1.0.wadus').to_s).to be == '1.0.wadus' }
  end

  describe '#inspect' do
    example { expect(SemVer.parse('1.0.0').inspect).to be == '<Version: 1.0.0>' }
    example { expect(SemVer.parse('1.0.0-rc15').inspect).to be == '<Version: 1.0.0-rc15>' }
    example { expect(SemVer.parse('1.0.wadus').inspect).to be == '<InvalidVersion: 1.0.wadus>' }
  end
end
