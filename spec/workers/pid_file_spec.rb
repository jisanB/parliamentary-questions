require 'spec_helper' 

describe MailWorker::PidFile do
  let(:pid_path) { '/tmp/test.pid'                   }
  let(:pid_file) { MailWorker::PidFile.new(pid_path) }

  before(:each) do
    File.delete(pid_path) if File.exists?(pid_path)
  end

  it 'will create the subdirs for the pidfile if they dont exist' do
    x_parent_dir = "#{Rails.root}/tmpx"
    x_pid_dir    = "#{Rails.root}/tmpx/xxx"
    x_pid_path   = "#{x_pid_dir}/test.pid"
    FileUtils.remove_entry_secure(x_parent_dir) if Dir.exist?(x_parent_dir)
    Dir.unlink(x_pid_dir) if Dir.exist?(x_pid_dir)
    expect(Dir.exist?(x_pid_dir)).to be false

    pidfile = MailWorker::PidFile.new(x_pid_path)
    pidfile.pid = '777'
    expect(File.exist?(x_pid_path)).to be true
    FileUtils.remove_entry_secure(x_parent_dir)
  end

  it '#initialize - creates a pid file with a path and a max age' do
    expect(pid_file.path).to eq pid_path
  end

  it '#present? - checks whether a pid file is present' do
    expect(pid_file).not_to be_present

    File.open(pid_path, 'w') {}
    expect(pid_file).to be_present
  end

  it '#pid - returns the pid file content' do
    File.open(pid_path, 'w') { |f| f.write('123')}

    expect(pid_file.pid).to eq '123'
  end

  it '#pid= - sets the pid value' do
    pid_file.pid = '345'

    expect(pid_file.pid).to eq '345'
  end

  it '#delete - deletes the file with a given pid string' do
    pid_file.pid = '678'

    pid_file.delete('123')
    expect(pid_file).to be_present

    pid_file.delete('678')
    expect(pid_file).not_to be_present
  end
end