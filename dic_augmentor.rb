require "fileutils"

class DicAugmentor
  InvalidDictionaryName = Class.new ArgumentError
  LOCAL_DICT_PATH = "~/Library/Spelling/LocalDictionary"
  DICTS = {
    med: "./medical_terms.txt",
    tech: "./technical_terms.txt"
  }

  def initialize
    @dict_path = File.expand_path LOCAL_DICT_PATH
    @merged_words = []
    open_local_dict_file
  end

  def augment_from_dict(dict)
    path = DICTS[dict] || raise(InvalidDictionaryName, dict)
    @word_file = File.open path
    puts "#{self.class} will augment AppleSpell with words from #{path}"
    augment!
  end

  def augment_from_file(path)
    begin
      @word_file = File.open path
    rescue Errno::ENOENT => e
      puts "[#{self.class}] could not find new dictionary file at \"#{word_file}\""
      exit 1
    end
    puts "#{self.class} will augment AppleSpell with words from #{path}"
    augment!
  end

  def augment!
    backup_local_dict
    merge_new_dict
    alphabetize_merged_dict
    write_merged_dict_to_local_dict
    restart_applespell
  end

  private

  def open_local_dict_file
    @local_dict = File.open @dict_path
  rescue Errno::ENOENT => e
    puts "[#{self.class}] could not find local dictionary file at #{@dict_path}"
    exit 2
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
      puts "Could not reset spell checker, you may need to type into a system text field/area to automatically restart it."
    end
  end

  def get_words(file_handle)
    file_handle.readlines.map { |l| l.chomp.split " " }.flatten
  end
end