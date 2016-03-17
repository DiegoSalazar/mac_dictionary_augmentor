require "fileutils"

class DicAugmentor
  LOCAL_DICT_PATH = "~/Library/Spelling/LocalDictionary"

  def initialize(word_file)
    @word_file = word_file
    @dict_path = File.expand_path LOCAL_DICT_PATH
    @merged_words = []
    open_dict_files
  end

  def augment!
    backup_local_dict
    merge_new_dict
    alphabetize_merged_dict
    write_merged_dict_to_local_dict
    restart_applespell
  end

  private

  def open_dict_files
    begin
      @word_file = File.open @word_file
    rescue Errno::ENOENT => e
      puts "[#{self.class}] could not find new dictionary file at #{word_file}"
      exit 1
    end

    begin
      @local_dict = File.open @dict_path
    rescue Errno::ENOENT => e
      puts "[#{self.class}] could not find local dictionary file at #{@dict_path}"
      exit 2
    end
  end

  def backup_local_dict
    FileUtils.cp @dict_path, "#{@dict_path}.backup"
  end

  def merge_new_dict
    @merged_words = get_words(@local_dict) | get_words(@word_file)
  end

  def alphabetize_merged_dict
    @merged_words.sort!
  end

  def write_merged_dict_to_local_dict
    print "Writing new words into Spell Check Dictionary..."
    File.open(@dict_path, "w") { |f| f.puts @merged_words }
    puts " Done."
  end

  def restart_applespell
    if system "killall AppleSpell"
      puts "Your Spell Checker has been augmented."
    else
      puts "Could not reset spell checker, you may need to reboot."
    end
  end

  def get_words(file_handle)
    file_handle.readlines.map &:chomp
  end
end