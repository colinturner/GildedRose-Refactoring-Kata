# require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'gilded_rose'

describe GildedRose do
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BRIE = "Aged Brie"
  BACKSTAGE = "Backstage passes to a TAFKAL80ETC concert"
  APPLE = "Apple"
  CONJURED = "Conjured"

  describe "#update_quality" do

    before(:each) do
      @items = [Item.new(SULFURAS, 0, 80), Item.new(BRIE, 10, 30), Item.new(BACKSTAGE, 10, 30), Item.new(APPLE, 10, 30), Item.new(CONJURED, 10, 30)]
      @rose = GildedRose.new(@items)
      @rose.update_quality

      @items_expired = [Item.new(SULFURAS, 0, 80), Item.new(BRIE, 0, 30), Item.new(BACKSTAGE, 0, 30), Item.new(APPLE, 0, 30), Item.new(CONJURED, 10, 30)]
      @rose_expired = GildedRose.new(@items_expired)
      @rose_expired.update_quality

      @backstage_9days = [Item.new(BACKSTAGE, 9, 30)]
      @rose_9days = GildedRose.new(@backstage_9days)
      @rose_9days.update_quality

      @backstage_4days = [Item.new(BACKSTAGE, 4, 30)]
      @rose_4days = GildedRose.new(@backstage_4days)
      @rose_4days.update_quality
    end

    context "General item" do

      context "within sell_in date, each day:" do
        it "does not change the name" do
          expect(@items[3].name).to eq "Apple"
        end

        it "decreases quality by 1" do
          expect(@items[3].quality).to eq 29
        end

        it "decreases sell_in by 1" do
          expect(@items[3].sell_in).to eq 9
        end
      end

      context "out of sell_in date, each day:" do
        it "decreases quality by 2" do
          expect(@items_expired[3].quality).to eq 28
        end

        it "quality never lowers past 0" do
          (0..100).each { @rose_expired.update_quality }
          expect(@items_expired[3].quality).to eq 0
        end

        it "quality never raises above 50" do
          (0..100).each { @rose_expired.update_quality }
          expect(@items_expired[1].quality).to eq 50
        end
      end


    end

    context "Sulfuras" do
      context "each day:" do
        it "decreases quality by 0" do
          expect(@items[0].quality).to eq 80
        end

        it "decreases sell_in by 0" do
          expect(@items[0].sell_in).to eq 0
        end
      end
    end


    context "Brie" do
      context "each day:" do
        it "increases quality by 1" do
          expect(@items[1].quality).to eq 31
        end
      end
    end


    context "Backstage" do
      context "each day:" do
        it "increases quality by 2 when sell_in <= 10" do
          expect(@backstage_9days[0].quality).to eq 32
        end

        it "increases quality by 3 when sell_in <= 5" do
          expect(@backstage_4days[0].quality).to eq 33
        end

        it "quality equals 0 after concert" do
          expect(@items_expired[2].quality).to eq 0
        end
      end
    end

    context "Conjured" do
      context "each day:" do
        xit "decreases quality by 2" do
          expect(@items[4].quality).to eq 28
        end
      end
    end
  end


end
